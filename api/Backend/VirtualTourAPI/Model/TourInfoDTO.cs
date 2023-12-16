using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class TourInfoDTO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; }
        [FirestoreProperty]
        public required string Name { get; set; }
    }
}
