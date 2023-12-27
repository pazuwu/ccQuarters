using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class NewTourDBO
    {
        [FirestoreProperty]
        public required string Name { get; set; }
        [FirestoreProperty]
        public required string OwnerId { get; set; }
        [FirestoreProperty]
        public string? PrimarySceneId { get; set; }
    }
}
