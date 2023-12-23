using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    public class TourUpdate
    {
        public string? Name { get; set; }
        public string? PrimarySceneId { get; set; }
    }
}
