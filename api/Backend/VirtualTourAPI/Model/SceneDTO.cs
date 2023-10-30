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

        [FirestoreProperty]
        public string? Photo360Id { get; set; }

        public List<LinkDTO>? Links { get; set; }
    }
}
