using System.Numerics;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace VirtualTourProcessingServer.OperationExecutors.Render
{
    public class NSCamera
    {
        [JsonPropertyName("w")]
        public required int Width { get; set; }
        [JsonPropertyName("h")]
        public required int Height { get; set; }
        [JsonPropertyName("fl_x")]
        public required double FocalLengthX { get; set; }
        [JsonPropertyName("fl_y")]
        public required double FocalLengthY { get; set; }
        [JsonPropertyName("cx")]
        public required double PrincipalPointX { get; set; }
        [JsonPropertyName("cy")]
        public required double PrincipalPointY { get; set; }
        [JsonPropertyName("frames")]
        public required List<NSFrame> Frames { get; set; }
    }

    public class NSFrame
    {
        [JsonPropertyName("file_path")]
        public required string FilePath { get; set; }
        [JsonPropertyName("transform_matrix")]
        public required List<List<float>> TransformMatrix { get; set; }
    }
}
