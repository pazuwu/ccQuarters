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

            var mockedColmapExecutor = new Mock<IColmapExecutor>();
            mockedColmapExecutor.Setup(e => e.Process(It.IsAny<ColmapParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Once());

            var mockedTrainExecutor = new Mock<ITrainExecutor>();
            mockedTrainExecutor.Setup(e => e.Train(It.IsAny<TrainParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedRenderExecutor = new Mock<IRenderExecutor>();
            mockedRenderExecutor.Setup(e => e.Render(It.IsAny<RenderParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            var mockedLogger = new Mock<ILogger<OperationRunner>>();

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            var operationRunner = new OperationRunner(mockedLogger.Object, mockedMadiator.Object, mockedOptions.Object, 
                mockedTrainExecutor.Object, mockedColmapExecutor.Object, mockedRenderExecutor.Object);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedColmapExecutor, mockedTrainExecutor, mockedRenderExecutor, mockedMadiator);
        }

        [TestMethod]
        public void OperationRunnerRunsTrain()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Train);

            var mockedColmapExecutor = new Mock<IColmapExecutor>();
            mockedColmapExecutor.Setup(e => e.Process(It.IsAny<ColmapParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedTrainExecutor = new Mock<ITrainExecutor>();
            mockedTrainExecutor.Setup(e => e.Train(It.IsAny<TrainParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Once());

            var mockedRenderExecutor = new Mock<IRenderExecutor>();
            mockedRenderExecutor.Setup(e => e.Render(It.IsAny<RenderParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            var mockedLogger = new Mock<ILogger<OperationRunner>>();

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            var operationRunner = new OperationRunner(mockedLogger.Object, mockedMadiator.Object, mockedOptions.Object, 
                mockedTrainExecutor.Object, mockedColmapExecutor.Object, mockedRenderExecutor.Object);
            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);

            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedColmapExecutor, mockedTrainExecutor, mockedRenderExecutor, mockedMadiator);
        }

        [TestMethod]
        public void OperationRunnerRunsRender()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Render);

            var mockedColmapExecutor = new Mock<IColmapExecutor>();
            mockedColmapExecutor.Setup(e => e.Process(It.IsAny<ColmapParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedTrainExecutor = new Mock<ITrainExecutor>();
            mockedTrainExecutor.Setup(e => e.Train(It.IsAny<TrainParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedRenderExecutor = new Mock<IRenderExecutor>();
            mockedRenderExecutor.Setup(e => e.Render(It.IsAny<RenderParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Once());

            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            var mockedLogger = new Mock<ILogger<OperationRunner>>();

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            var operationRunner = new OperationRunner(mockedLogger.Object, mockedMadiator.Object, mockedOptions.Object, 
                mockedTrainExecutor.Object, mockedColmapExecutor.Object, mockedRenderExecutor.Object);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedColmapExecutor, mockedTrainExecutor, mockedRenderExecutor, mockedMadiator);
        }
    }
}
