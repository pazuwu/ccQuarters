using FluentAssertions;
using MediatR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.Processing;

namespace VirtualTourProcessingServer.UnitTests
{
    [TestClass]
    public class OperationRunnerTests
    {
        [TestMethod]
        public void OperationRunnerRunsColmap()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Colmap);

            var mockedColmapExecutor = CreateExecutorMock(Times.Once());
            var mockedTrainExecutor = CreateExecutorMock(Times.Never());
            var mockedRenderExecutor = CreateExecutorMock(Times.Never());

            var mockedMadiator = CreateMediatorMock();
            var mockedLogger = CreateLoggerMock();
            var mockedOptions = CreateOptionsMock();
            ExecutorResolver resolver = operationStage => operationStage switch
            {
                OperationStage.Colmap => mockedColmapExecutor.Object,
                OperationStage.Train => mockedTrainExecutor.Object,
                OperationStage.Render => mockedRenderExecutor.Object,
                _ => null,
            };


            var operationRunner = new OperationRunner(mockedLogger.Object, mockedMadiator.Object, mockedOptions.Object, resolver);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedColmapExecutor, mockedTrainExecutor, mockedRenderExecutor, mockedMadiator);
        }

        [TestMethod]
        public void OperationRunnerRunsTrain()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Train);

            var mockedColmapExecutor = CreateExecutorMock(Times.Never());
            var mockedTrainExecutor = CreateExecutorMock(Times.Once());
            var mockedRenderExecutor = CreateExecutorMock(Times.Never());

            var mockedMadiator = CreateMediatorMock();
            var mockedLogger = CreateLoggerMock();
            var mockedOptions = CreateOptionsMock();
            ExecutorResolver resolver = operationStage => operationStage switch
            {
                OperationStage.Colmap => mockedColmapExecutor.Object,
                OperationStage.Train => mockedTrainExecutor.Object,
                OperationStage.Render => mockedRenderExecutor.Object,
                _ => null,
            };

            var operationRunner = new OperationRunner(mockedLogger.Object, mockedMadiator.Object, mockedOptions.Object, resolver);
            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);

            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedColmapExecutor, mockedTrainExecutor, mockedRenderExecutor, mockedMadiator);
        }

        [TestMethod]
        public void OperationRunnerRunsRender()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Render);

            var mockedColmapExecutor = CreateExecutorMock(Times.Never());
            var mockedTrainExecutor = CreateExecutorMock(Times.Never());
            var mockedRenderExecutor = CreateExecutorMock(Times.Once());

            var mockedMadiator = CreateMediatorMock();
            var mockedLogger = CreateLoggerMock();
            var mockedOptions = CreateOptionsMock();
            ExecutorResolver resolver = operationStage => operationStage switch
            {
                OperationStage.Colmap => mockedColmapExecutor.Object,
                OperationStage.Train => mockedTrainExecutor.Object,
                OperationStage.Render => mockedRenderExecutor.Object,
                _ => null,
            };

            var operationRunner = new OperationRunner(mockedLogger.Object, mockedMadiator.Object, mockedOptions.Object, resolver);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedColmapExecutor, mockedTrainExecutor, mockedRenderExecutor, mockedMadiator);
        }

        private Mock<IOperationExecutor> CreateExecutorMock(Times executiontTimes)
        {
            var mockedExecutor = new Mock<IOperationExecutor>();
            mockedExecutor.Setup(e => e.Execute(It.IsAny<ExecutorParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(executiontTimes);

            return mockedExecutor;
        }

        private Mock<IMediator> CreateMediatorMock()
        {
            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            return mockedMadiator;
        }

        private Mock<IOptions<ProcessingOptions>> CreateOptionsMock()
        {
            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            return mockedOptions;
        }

        private Mock<ILogger<OperationRunner>> CreateLoggerMock()
        {
            return new Mock<ILogger<OperationRunner>>();
        }
    }
}
