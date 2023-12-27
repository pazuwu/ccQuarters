using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class LinkDBO
    {
        [FirestoreDocumentId]
        public required string Id { get; set; }
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
