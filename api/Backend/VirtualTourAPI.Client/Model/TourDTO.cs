
namespace VirtualTourAPI.Client.Model
{
    public class TourDTO
    {
        public string? Id { get; set; }
        public required string Name { get; set; }

        public List<AreaDTO>? Areas { get; set; }
        public List<SceneDTO>? Scenes { get; set; }
        public List<LinkDTO>? Links { get; set; }
    }
}
