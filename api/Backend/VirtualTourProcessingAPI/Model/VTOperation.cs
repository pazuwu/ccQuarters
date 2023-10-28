using Google.Cloud.Firestore;

namespace VirtualTourProcessingServer.Model
{
    [FirestoreData]
    public class VTOperation
    {
        [FirestoreDocumentId]
        public string? OperationId { get; set; }

        [FirestoreProperty("areaId")]
        public string? AreaId { get; set; }

        [FirestoreProperty("status", ConverterType = typeof(FirestoreEnumNameConverter<OperationStatus>))]
        public OperationStatus Status { get; set; }

        [FirestoreDocumentUpdateTimestamp]
        public Timestamp LastModified { get; set; }
    }

    public enum OperationStatus
    {
        Colmap,
        Train,
        Render,
    }
}
