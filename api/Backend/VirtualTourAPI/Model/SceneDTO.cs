using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class SceneDTO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; }

        [FirestoreProperty]
        public string? ParentId { get; set; }

        public string? Photo360Url { get; set; }
    }
}
