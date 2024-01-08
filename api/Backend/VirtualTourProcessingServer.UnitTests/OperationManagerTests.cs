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
                StorageDirectory = "",
            };

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(options);

            HubResolver hubResolver = (operationStage, hub, multiHub) =>
            {
                return operationStage switch
                {
                    OperationStage.Colmap
                    or OperationStage.Train
                    or OperationStage.Render => hub,

                    OperationStage.Waiting
                    or OperationStage.PrepareRender
                    or OperationStage.SavingRender
                    or OperationStage.Finished => multiHub,

                    _ => null,
                };
            };

            _manager = new OperationManager(loggerMock.Object, mockedOptions.Object, _multiRunner, _runner, hubResolver);
        }

        [TestMethod]
        [DynamicData(nameof(OperationsFactory.ProduceRunnerStages), typeof(OperationsFactory), DynamicDataSourceType.Method)]
        public void RegisterOperationExecutesCorrectRunner(OperationStage stage)
        {
            var operation = OperationsFactory.CreateOperation(stage);
            _manager.RegisterNewOperations(new List<VTOperation>() { operation });

            if(OperationsFactory.RunnerStages.Contains(stage))
                _runner.RunningOperation.Should().NotBeNull()
                    .And.Subject.Should().BeSameAs(operation);
            else
                _multiRunner.RunningOperations.Should().Contain(operation);
        }

        [TestMethod]
        [DynamicData(nameof(OperationsFactory.ProduceRunnerStages), typeof(OperationsFactory), DynamicDataSourceType.Method)]
        public void RunNextRunsNextOperationInRunner(OperationStage stage)
        {
            var firstOperation = OperationsFactory.CreateOperation(stage);
            var secondOperation = OperationsFactory.CreateOperation(stage);

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
        [DynamicData(nameof(OperationsFactory.ProduceMultiRunnerStages), typeof(OperationsFactory), DynamicDataSourceType.Method)]
        public void RunNextRunsNextOperationInMultiRunner(OperationStage stage)
        {
            _multiRunner.MaxMultiprocessingThreadsMock = 2;

            var firstOperation = OperationsFactory.CreateOperation(stage);
            var secondOperation = OperationsFactory.CreateOperation(stage);
            var thirdOperation = OperationsFactory.CreateOperation(stage);

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
    }
}