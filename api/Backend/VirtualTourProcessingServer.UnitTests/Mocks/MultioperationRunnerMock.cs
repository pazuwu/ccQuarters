using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.UnitTests.Mocks
{
    internal class MultioperationRunnerMock : IMultiOperationRunner
    {
        private Queue<VTOperation> _runningOperations { get; } = new();

        public IReadOnlyCollection<VTOperation> RunningOperations => _runningOperations;
        public int? MaxMultiprocessingThreadsMock { get; set; }


        public void Run(VTOperation operation)
        {
            _runningOperations.Enqueue(operation);
        }

        public bool TryRegister(VTOperation operation)
        {
            return MaxMultiprocessingThreadsMock.HasValue ? 
                _runningOperations.Count < MaxMultiprocessingThreadsMock.Value
                : true;
        }

        public void MockedEndProcessing()
        {
            _runningOperations.Dequeue();
        }
    }
}
