
namespace VirtualTourAPI.Client.Requests
{
    internal class PostSceneRequest
    {
        public required string Name { get; set; }   
        public string? ParentId { get; set; }
    }
}
