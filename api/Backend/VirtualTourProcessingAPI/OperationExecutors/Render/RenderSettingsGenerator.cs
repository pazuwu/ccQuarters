using Microsoft.Extensions.Options;
using System.Numerics;
using System.Text.Json;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors.Render
{
    public class RenderSettingsGenerator : IRenderSettingsGenerator
    {
        private readonly RenderOptions _renderOptions;

        public RenderSettingsGenerator(IOptions<RenderOptions> renderOptions)
        {
            _renderOptions = renderOptions.Value;
        }

        public async Task<ExecutorResponse> GenerateSettings(GenerateRenderSettingsParameters parameters)
        {
            if (!File.Exists(parameters.ColmapTransformsFilePath))
                return ExecutorResponse.Problem($"Provided colmap file doesn't exist: {parameters.OutputFilePath}");

            var transforms = await File.ReadAllTextAsync(parameters.ColmapTransformsFilePath);

            var cameraModel = JsonSerializer.Deserialize<NSCamera>(transforms);

            if (cameraModel == null)
                return ExecutorResponse.Problem($"Provided colmap file is in wrong format: {parameters.OutputFilePath}");


            var meanPosition = new Vector3();
            var framesCount = 0;

            foreach (var frame in cameraModel.Frames)
            {
                if (frame.TransformMatrix.Count >= 3
                    && frame.TransformMatrix[0].Count >= 3
                    && frame.TransformMatrix[1].Count >= 3
                    && frame.TransformMatrix[2].Count >= 3)
                {
                    for (int i = 0; i < 3; i++)
                    {
                        meanPosition[i] += frame.TransformMatrix[i][3];
                    }

                    framesCount++;
                }
            };

            for (int i = 0; i < 3; i++)
                meanPosition[i] /= framesCount;

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

            await File.WriteAllTextAsync(parameters.OutputFilePath, serializedSettings);
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
