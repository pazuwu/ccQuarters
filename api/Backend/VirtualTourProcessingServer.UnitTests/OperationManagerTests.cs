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
            var operation = new VTOperation()
            {
                AreaId = "",
                OperationId = "",
                TourId = "",
                Stage = stage,
            };
            _manager.RegisterNewOperations(new List<VTOperation>() { operation });

            if(_runnerStages.Contains(stage))
                _runner.RunningOperation.Should().NotBeNull()
                    .And.Subject.Should().BeSameAs(operation);
            else
                _multiRunner.RunningOperations.Should().Contain(operation);
        }

        private static readonly OperationStage[] _runnerStages = { OperationStage.Colmap, OperationStage.Train, OperationStage.Render };

        public static IEnumerable<object[]> Stages => Enum.GetValues<OperationStage>().Select(stage => new object[] { stage });
    }
}