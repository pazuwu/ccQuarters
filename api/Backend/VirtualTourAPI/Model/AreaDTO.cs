using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class AreaDTO
    {
        [FirestoreDocumentId]
        public string? Id { get; set; } 

        [FirestoreProperty]
        public string? TransformsId { get; set; }

        [FirestoreProperty]
        public string? Name { get; set; }

        [FirestoreProperty]
        public List<string>? PhotoIds { get; set; }
        
        public List<SceneDTO>? Scenes { get; set; }  
    }
}
