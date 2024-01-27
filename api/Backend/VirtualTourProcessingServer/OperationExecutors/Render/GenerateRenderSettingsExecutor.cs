using Microsoft.Extensions.Options;
using System.Numerics;
using System.Text.Json;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors.Render
{
    public class GenerateRenderSettingsExecutor : IOperationExecutor
    {
        private readonly RenderOptions _renderOptions;

        public GenerateRenderSettingsExecutor(IOptions<RenderOptions> renderOptions)
        {
            _renderOptions = renderOptions.Value;
        }

        public async Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            var outputPath = Path.Combine(parameters.AreaDirectory, "render_settings.json");

            var meanPosition = new Vector3(0, 0, 0);

            var meanPositionMatrix = Matrix4x4.CreateRotationX(-(float)Math.PI / 2) * Matrix4x4.CreateTranslation(meanPosition);
            var transposedMeanPositionMatrix = MatrixToArray(Matrix4x4.Transpose(meanPositionMatrix));
            var serializedTransposedMeanPositionMatrix = JsonSerializer.Serialize(transposedMeanPositionMatrix);

            var renderSettings = new NSRenderSettings()
            {
                CameraPath = new() {
                    new NSCameraPoint()
                    {
                        Aspect = 1.0f,
                        CameraToWorld = MatrixToArray(meanPositionMatrix),
                        Fov = 50,
                    }, 
                },
                CameraType = CameraType.equirectangular,
                Fps = 1,
                Seconds = 1,
                IsCycle = true,
                RenderHeight = _renderOptions.RenderHeight,
                RenderWidth = _renderOptions.RenderWidth,
                KeyFrames = new List<NSKeyFrame>()
                {
                    new NSKeyFrame()
                    {
                        Aspect = 1,
                        Fov = 50,
                        Matrix = serializedTransposedMeanPositionMatrix,
                        Properties = "[[\"FOV\",50],[\"NAME\",\"Camera 0\"],[\"TIME\",0]]"
                    }
                },
                SmoothnessValue = 1,
            };

            var serializedSettings = JsonSerializer.Serialize(renderSettings);

            await File.WriteAllTextAsync(outputPath, serializedSettings);
            return ExecutorResponse.Ok();
        }

        private float[] MatrixToArray(Matrix4x4 matrix)
        {
            return new float[]
            {
                matrix.M11, matrix.M12, matrix.M13, matrix.M14,
                matrix.M21, matrix.M22, matrix.M23, matrix.M24,
                matrix.M31, matrix.M32, matrix.M33, matrix.M34,
                matrix.M41, matrix.M42, matrix.M43, matrix.M44
            };
        }
    }
}
