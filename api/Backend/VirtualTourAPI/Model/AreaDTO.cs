using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class AreaDTO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; } 

        [FirestoreProperty]
        public string? TransformsId { get; set; }

        [FirestoreProperty]
        public string? Name { get; set; }

        [FirestoreProperty]
        public string[]? PhotoIds { get; set; }
    }
}
