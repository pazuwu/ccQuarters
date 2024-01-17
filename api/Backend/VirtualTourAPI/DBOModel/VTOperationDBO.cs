using Google.Cloud.Firestore;

namespace VirtualTourAPI.DBOModel
{
    [FirestoreData]
    public class VTOperationDBO
    {
        [FirestoreProperty]
        public required string AreaId { get; set; }
        [FirestoreProperty]
        public required string TourId { get; set; }
        [FirestoreProperty]
        public required string UserEmail { get; set; }
        [FirestoreProperty]
        public int ProcessingAttempts { get; set; } = 0;

        [FirestoreProperty(ConverterType = typeof(FirestoreEnumNameConverter<OperationStageDBO>))]
        public OperationStageDBO Stage { get; set; } = OperationStageDBO.Waiting;

        [FirestoreProperty(ConverterType = typeof(FirestoreEnumNameConverter<OperationStatusDBO>))]
        public OperationStatusDBO Status { get; set; } = OperationStatusDBO.Ok;
    }

    public enum OperationStageDBO
    {
        Waiting,
        Colmap,
        Train,
        PrepareRender,
        Render,
        SavingRender,
        Finished,
    }

    public enum OperationStatusDBO
    {
        Ok,
        Error,
    }
}
