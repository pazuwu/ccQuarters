using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class NewLinkDBO
    {
        [FirestoreProperty]
        public string? Text { get; set; }
        [FirestoreProperty]
        public required string DestinationId { get; set; }
        [FirestoreProperty]
        public string? ParentId { get; set; }
        [FirestoreProperty]
        public GeoPoint? Position { get; set; }
        [FirestoreProperty]
        public GeoPoint? NextOrientation { get; set; }
    }
}
