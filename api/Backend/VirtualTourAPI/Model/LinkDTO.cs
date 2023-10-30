using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class LinkDTO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; }

        [FirestoreProperty]
        public string? ParentId { get; set; }

        [FirestoreProperty]
        public string? Text { get; set; }

        [FirestoreProperty]
        public string? DestinationId { get; set; }

        [FirestoreProperty]
        public GeoPoint? Position { get; set; }

        [FirestoreProperty]
        public GeoPoint? NextOrientation { get; set; }
    }
}
