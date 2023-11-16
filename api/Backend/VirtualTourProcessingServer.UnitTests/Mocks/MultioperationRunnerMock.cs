using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.UnitTests.Mocks
{
    internal class MultioperationRunnerMock : IMultiOperationRunner
    {
        private List<VTOperation> _runningOperations { get; } = new();

        public IReadOnlyList<VTOperation> RunningOperations => _runningOperations;

        public void Run(VTOperation operation)
        {
            _runningOperations.Add(operation);
        }

        public bool TryRegister(VTOperation operation)
        {
            return true;
        }
    }
}
