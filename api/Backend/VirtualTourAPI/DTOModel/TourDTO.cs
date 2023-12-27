using VirtualTourAPI.Model;

namespace VirtualTourAPI.DTOModel
{
    public class TourDTO
    {
        public required string Id { get; set; }
        public required string Name { get; set; }
        public required string OwnerId { get; set; }
        public string? PrimarySceneId { get; set; }

        public List<SceneDTO>? Scenes { get; set; }
        public List<LinkDTO>? Links { get; set; }
    }
}
