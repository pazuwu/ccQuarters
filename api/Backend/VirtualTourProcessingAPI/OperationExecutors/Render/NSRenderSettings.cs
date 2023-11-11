using System.Text.Json.Serialization;

namespace VirtualTourProcessingServer.OperationExecutors.Render
{
    public class NSRenderSettings
    {
        [JsonPropertyName("camera_path")]
        public required List<NSCameraPoint> CameraPath { get; set; }
        [JsonPropertyName("camera_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public required CameraType CameraType { get; set; }
        [JsonPropertyName("fps")]
        public required int Fps { get; set; }
        [JsonPropertyName("is_cycle")]
        public required bool IsCycle { get; set; }
        [JsonPropertyName("keyframes")]
        public required List<NSKeyFrame> KeyFrames { get; set; }
        [JsonPropertyName("render_height")]
        public required int RenderHeight { get; set; }
        [JsonPropertyName("render_width")]
        public required int RenderWidth { get; set; }
        [JsonPropertyName("seconds")]
        public required int Seconds { get; set; }
        [JsonPropertyName("smoothness_value")]
        public required int SmoothnessValue { get; set; }
    }

    public class NSCameraPoint
    {
        [JsonPropertyName("aspect")]
        public required float Aspect { get; set; }
        [JsonPropertyName("camera_to_world")]
        public required float[] CameraToWorld { get; set; }
        [JsonPropertyName("fov")]
        public required float Fov { get; set; }
    }

    public class NSKeyFrame
    {
        [JsonPropertyName("aspect")]
        public required float Aspect { get; set; }
        [JsonPropertyName("fov")]
        public required float Fov { get; set; }
        [JsonPropertyName("matrix")]
        public required string Matrix { get; set; }
        [JsonPropertyName("properties")]
        public required string Properties { get; set; }
    }

    public enum CameraType
    {
        equirectangular,
    }
}
