using Google.Cloud.Firestore;

namespace VirtualTourAPI.DTOModel
{
    [FirestoreData]
    public class TourInfoDTO
    {
        [FirestoreDocumentId]
        public required string Id { get; set; }
        [FirestoreProperty]
        public required string Name { get; set; }
    }
}
