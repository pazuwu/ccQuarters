using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.UnitTests
{
    public static class OperationsFactory
    {
        public static VTOperation CreateOperation(OperationStage stage)
        {
            return new VTOperation()
            {
                AreaId = Guid.NewGuid().ToString(),
                OperationId = Guid.NewGuid().ToString(),
                TourId = Guid.NewGuid().ToString(),
                Stage = stage,
            };
        }

        public static readonly OperationStage[] RunnerStages = { OperationStage.Colmap, OperationStage.Train, OperationStage.Render };

        public static IEnumerable<object[]> ProduceRunnerStages() => RunnerStages.Select(stage => new object[] { stage });
        public static IEnumerable<object[]> ProduceMultiRunnerStages() => Enum.GetValues<OperationStage>().Except(RunnerStages).Select(stage => new object[] { stage });
        public static IEnumerable<object[]> ProduceStages() => Enum.GetValues<OperationStage>().Select(stage => new object[] { stage });
    }
}
