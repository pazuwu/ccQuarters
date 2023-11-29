using FluentAssertions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Processing;
using VirtualTourProcessingServer.Processing.Interfaces;
using VirtualTourProcessingServer.UnitTests.Mocks;

namespace VirtualTourProcessingServer.UnitTests
{
    [TestClass]
    public class OperationManagerTests
    {
        private readonly OperationRunnerMock _runner = new();
        private readonly MultioperationRunnerMock _multiRunner = new();
        private readonly IOperationManager _manager;

        public OperationManagerTests()
        {
            var loggerMock = new Mock<ILogger<OperationManager>>();
            var options = new ProcessingOptions()
            {
                MaxProcessingAttempts = 1,
            };

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(options);

            _manager = new OperationManager(loggerMock.Object, mockedOptions.Object, _multiRunner, _runner);
        }

        [TestMethod]
        [DynamicData(nameof(Stages), DynamicDataSourceType.Property)]
        public void RegisterOperationExecutesCorrectRunner(OperationStage stage)
        {
            var operation = CreateOperation(stage);
            _manager.RegisterNewOperations(new List<VTOperation>() { operation });

            if(_runnerStages.Contains(stage))
                _runner.RunningOperation.Should().NotBeNull()
                    .And.Subject.Should().BeSameAs(operation);
            else
                _multiRunner.RunningOperations.Should().Contain(operation);
        }

        [TestMethod]
        [DynamicData(nameof(RunnerStages), DynamicDataSourceType.Property)]
        public void RunNextRunsNextOperationInRunner(OperationStage stage)
        {
            var firstOperation = CreateOperation(stage);
            var secondOperation = CreateOperation(stage);

            _manager.RegisterNewOperations(new List<VTOperation>() { firstOperation, secondOperation });

            _runner.RunningOperation.Should().NotBeNull()
                .And.Subject.Should().BeSameAs(firstOperation);

            _manager.RunNext(stage);
            _runner.RunningOperation.Should().NotBeNull()
                .And.Subject.Should().BeSameAs(firstOperation);

            _runner.MockedEndProcessing();
            _manager.RunNext(stage);

            _runner.RunningOperation.Should().NotBeNull()
                .And.Subject.Should().BeSameAs(secondOperation);
        }

        [TestMethod]
        [DynamicData(nameof(MultiRunnerStages), DynamicDataSourceType.Property)]
        public void RunNextRunsNextOperationInMultiRunner(OperationStage stage)
        {
            _multiRunner.MaxMultiprocessingThreadsMock = 2;

            var firstOperation = CreateOperation(stage);
            var secondOperation = CreateOperation(stage);
            var thirdOperation = CreateOperation(stage);

            _manager.RegisterNewOperations(new List<VTOperation>() { firstOperation, secondOperation, thirdOperation });

            _multiRunner.RunningOperations.Should().Contain(firstOperation)
                .And.Subject.Should().Contain(secondOperation);

            _manager.RunNext(stage);
            _multiRunner.RunningOperations.Should().Contain(new List<VTOperation>() { firstOperation, secondOperation })
                .And.Subject.Should().NotContain(thirdOperation);

            _multiRunner.MockedEndProcessing();
            _manager.RunNext(stage);

            _multiRunner.RunningOperations.Should().Contain(thirdOperation);
        }

        private static VTOperation CreateOperation(OperationStage stage)
        {
            return new VTOperation()
            {
                AreaId = Guid.NewGuid().ToString(),
                OperationId = Guid.NewGuid().ToString(),
                TourId = Guid.NewGuid().ToString(),
                Stage = stage,
            };
        }

        private static readonly OperationStage[] _runnerStages = { OperationStage.Colmap, OperationStage.Train, OperationStage.Render };

        public static IEnumerable<object[]> RunnerStages => _runnerStages.Select(stage => new object[] { stage });
        public static IEnumerable<object[]> MultiRunnerStages => Enum.GetValues<OperationStage>().Except(_runnerStages).Select(stage => new object[] { stage });
        public static IEnumerable<object[]> Stages => Enum.GetValues<OperationStage>().Select(stage => new object[] { stage });
    }
}