using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class TourInfoDBO
    {
        [FirestoreDocumentId]
        public required string Id { get; set; }
        [FirestoreProperty]
        public required string Name { get; set; }
    }
}
