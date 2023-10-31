using Google.Cloud.Firestore;

namespace VirtualTourProcessingServer.Model
{
    [FirestoreData]
    public class VTOperation
    {
        [FirestoreDocumentId]
        public string? OperationId { get; set; }

        [FirestoreProperty]
        public string? AreaId { get; set; }

        [FirestoreProperty(ConverterType = typeof(FirestoreEnumNameConverter<OperationStage>))]
        public OperationStage Stage { get; set; }

        [FirestoreDocumentUpdateTimestamp]
        public Timestamp LastModified { get; set; }

        [FirestoreProperty(ConverterType = typeof(FirestoreEnumNameConverter<OperationStatus>))]
        public OperationStatus Status { get; set; }

        [FirestoreProperty]
        public int ProcessingAttempts { get; set; }
    }

    public enum OperationStage
    {
        Waiting,
        PrepareData,
        Colmap,
        SavingColmap,
        Train,
        CleanupTrain,
        Render,
        SavingRender,
        Finished,
    }

    public enum OperationStatus
    {
        Ok,
        Error,
    }
}
