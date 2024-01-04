using Google.Cloud.Firestore;

namespace VirtualTourAPI.DTOModel
{
    public class AreaDTO
    {
        public required string Id { get; set; } 
        public required string Name { get; set; }
        public string? OperationId { get; set; }
    }
}
