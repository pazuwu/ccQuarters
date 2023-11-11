using Google.Cloud.Firestore;

namespace VirtualTourAPI.Requests
{
    public class PutLinkRequest
    {
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public GeoPoint? Position { get; set; }
        public GeoPoint? NextOrientation { get; set; }
    }
}
