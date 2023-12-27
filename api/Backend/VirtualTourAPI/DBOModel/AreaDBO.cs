using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class AreaDBO
    {
        [FirestoreDocumentId]
        public required string Id { get; set; }
        [FirestoreProperty]
        public required string Name { get; set; }
        [FirestoreProperty]
        public string? OperationId { get; set; }
    }
}
