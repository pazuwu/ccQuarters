using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class SceneDBO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; }
        [FirestoreProperty]
        public string? ParentId { get; set; }
        [FirestoreProperty]
        public string? Name { get; set; }
    }
}
