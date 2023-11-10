using Google.Cloud.Firestore;

namespace VirtualTourAPI.Model
{
    [FirestoreData]
    public class VTOperationDTO
    {
        [FirestoreProperty]
        public string? AreaId { get; set; }

        [FirestoreProperty]
        public string? TourId { get; set; }

        [FirestoreProperty]
        public int ProcessingAttempts { get; set; } = 0;
        
        [FirestoreProperty(ConverterType = typeof(FirestoreEnumNameConverter<OperationStage>))]
        public OperationStage Stage { get; set; } = OperationStage.Waiting;

        [FirestoreProperty(ConverterType = typeof(FirestoreEnumNameConverter<OperationStatus>))]
        public OperationStatus Status { get; set; } = OperationStatus.Ok;
    }

    public enum OperationStage
    {
        Waiting,
    }

    public enum OperationStatus
    {
        Ok,
    }
}
