using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class NewAreaDBO
    {
        [FirestoreProperty]
        public required string Name { get; set; }
    }
}
