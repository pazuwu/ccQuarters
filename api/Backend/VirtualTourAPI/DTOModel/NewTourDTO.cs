
namespace VirtualTourAPI.DTOModel
{
    public class NewTourDTO
    {
        public required string Name { get; set; }
        public required string OwnerId { get; set; }
        public string? PrimarySceneId { get; set; }
    }
}
