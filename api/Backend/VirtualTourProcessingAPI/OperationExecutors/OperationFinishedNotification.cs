using MediatR;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class OperationFinishedNotification : INotification
    {
        public VTOperation Operation { get; set; }
        public StatusCode StatusCode { get; set; }

        public OperationFinishedNotification(VTOperation operation, StatusCode statusCode)
        {
            Operation = operation;
            StatusCode = statusCode;
        }
    }
}
