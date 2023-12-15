namespace VirtualTourAPI.Requests
{
    public class PostSceneRequest
    {
        public required string Name { get; set; }
        public string? ParentId { get; set; }
    }
}
