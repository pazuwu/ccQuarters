using Google.Cloud.Firestore;

namespace VirtualTourAPI.DTOModel
{
    [FirestoreData]
    public class SceneDTO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; }

        [FirestoreProperty]
        public string? ParentId { get; set; }

        [FirestoreProperty]
        public string? Name { get; set; }

        public string? Photo360Url { get; set; }
    }
}
