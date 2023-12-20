using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class TourUpdate
    {
        [FirestoreProperty]
        public required string Name { get; set; }
    }
}
