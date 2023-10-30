using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class TourDTO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; }

        public List<AreaDTO>? Areas { get; set; }
    }
}
