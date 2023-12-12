using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.UnitTests.Mocks
{
    public class OperationRunnerMock : IOperationRunner
    {
        public VTOperation? RunningOperation { get; set; }

        public void Run(VTOperation operation)
        {
            RunningOperation = operation;
        }

        public bool TryRegister(VTOperation operation)
        {
            return RunningOperation == null;
        }

        public void MockedEndProcessing()
        { 
            RunningOperation = null;
        }
    }
}
