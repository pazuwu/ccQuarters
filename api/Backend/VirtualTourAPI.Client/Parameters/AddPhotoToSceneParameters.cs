
namespace VirtualTourAPI.Client.Parameters
{
    public class AddPhotoToSceneParameters
    {
        public required string TourId { get; set; }
        public required string SceneId { get; set; }
        public byte[]? PhotoInBytes { get; set; }
        public string? PhotoPath { get; set; }
    }
}
