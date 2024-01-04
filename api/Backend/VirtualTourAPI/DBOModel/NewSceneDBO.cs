using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class NewSceneDBO
    {
        [FirestoreProperty]
        public required string Name { get; set; }
        [FirestoreProperty]
        public string? ParentId { get; set; }
    }
}
