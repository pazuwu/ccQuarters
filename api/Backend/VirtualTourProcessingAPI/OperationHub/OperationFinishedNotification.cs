using MediatR;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public class OperationFinishedNotification : INotification
    {
        public VTOperation Operation { get; set; }

        public OperationFinishedNotification(VTOperation operation)
        {
            Operation = operation;
        }
    }
}
