using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class AreaPhotoDBO
    {
        [FirestoreDocumentId]
        public required string Id { get; set; }
    }
}
