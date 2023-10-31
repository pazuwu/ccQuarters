using MediatR;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.Services
{
    public class OperationNotification : INotification
    {
        public List<VTOperation> Operations { get; }

        public OperationNotification(List<VTOperation> operations)
        {
            Operations = operations;
        }
    }
}
