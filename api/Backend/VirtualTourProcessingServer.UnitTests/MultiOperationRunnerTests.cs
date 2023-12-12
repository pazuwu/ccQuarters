using MediatR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.Processing;
using VirtualTourProcessingServer.Model;
using FluentAssertions;

namespace VirtualTourProcessingServer.UnitTests
{
    [TestClass]
    public class MultiOperationRunnerTests
    {
        [TestMethod]
        public void MultiOperationRunnerRunsDownload()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.PrepareData);

            var mockedDownloadExecutor = new Mock<IDownloadExecutor>();
            mockedDownloadExecutor.Setup(e => e.DownloadPhotos(It.IsAny<DownloadParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Once());

            var mockedSettingsGenerator = new Mock<IRenderSettingsGenerator>();
            mockedSettingsGenerator.Setup(e => e.GenerateSettings(It.IsAny<GenerateRenderSettingsParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedUploadExecutor = new Mock<IUploadExecutor>();
            mockedUploadExecutor.Setup(e => e.SaveScenes(It.IsAny<UploadExecutorParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedCleanExecutor = new Mock<ICleanExecutor>();
            mockedCleanExecutor.Setup(c => c.CleanWorkingDirectory(It.IsAny<string>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            var mockedLogger = new Mock<ILogger<MultiOperationRunner>>();

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object, 
                mockedDownloadExecutor.Object, mockedSettingsGenerator.Object, mockedUploadExecutor.Object, mockedCleanExecutor.Object);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
        }

        [TestMethod]
        public void MultiOperationRunnerRunsPrepareRender()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.PrepareRender);

            var mockedDownloadExecutor = new Mock<IDownloadExecutor>();
            mockedDownloadExecutor.Setup(e => e.DownloadPhotos(It.IsAny<DownloadParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedSettingsGenerator = new Mock<IRenderSettingsGenerator>();
            mockedSettingsGenerator.Setup(e => e.GenerateSettings(It.IsAny<GenerateRenderSettingsParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Once());

            var mockedUploadExecutor = new Mock<IUploadExecutor>();
            mockedUploadExecutor.Setup(e => e.SaveScenes(It.IsAny<UploadExecutorParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedCleanExecutor = new Mock<ICleanExecutor>();
            mockedCleanExecutor.Setup(c => c.CleanWorkingDirectory(It.IsAny<string>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            var mockedLogger = new Mock<ILogger<MultiOperationRunner>>();

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object,
                mockedDownloadExecutor.Object, mockedSettingsGenerator.Object, mockedUploadExecutor.Object, mockedCleanExecutor.Object);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
        }

        [TestMethod]
        public void MultiOperationRunnerRunsSavingRender()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.SavingRender);

            var mockedDownloadExecutor = new Mock<IDownloadExecutor>();
            mockedDownloadExecutor.Setup(e => e.DownloadPhotos(It.IsAny<DownloadParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedSettingsGenerator = new Mock<IRenderSettingsGenerator>();
            mockedSettingsGenerator.Setup(e => e.GenerateSettings(It.IsAny<GenerateRenderSettingsParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedUploadExecutor = new Mock<IUploadExecutor>();
            mockedUploadExecutor.Setup(e => e.SaveScenes(It.IsAny<UploadExecutorParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Once());

            var mockedCleanExecutor = new Mock<ICleanExecutor>();
            mockedCleanExecutor.Setup(c => c.CleanWorkingDirectory(It.IsAny<string>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            var mockedLogger = new Mock<ILogger<MultiOperationRunner>>();

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object,
                mockedDownloadExecutor.Object, mockedSettingsGenerator.Object, mockedUploadExecutor.Object, mockedCleanExecutor.Object);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
        }

        [TestMethod]
        public void MultiOperationRunnerRunsCleaning()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Finished);

            var mockedDownloadExecutor = new Mock<IDownloadExecutor>();
            mockedDownloadExecutor.Setup(e => e.DownloadPhotos(It.IsAny<DownloadParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedSettingsGenerator = new Mock<IRenderSettingsGenerator>();
            mockedSettingsGenerator.Setup(e => e.GenerateSettings(It.IsAny<GenerateRenderSettingsParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedUploadExecutor = new Mock<IUploadExecutor>();
            mockedUploadExecutor.Setup(e => e.SaveScenes(It.IsAny<UploadExecutorParameters>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Never());

            var mockedCleanExecutor = new Mock<ICleanExecutor>();
            mockedCleanExecutor.Setup(c => c.CleanWorkingDirectory(It.IsAny<string>()))
                .Returns(Task.FromResult(ExecutorResponse.Ok()))
                .Verifiable(Times.Once());

            var mockedMadiator = new Mock<IMediator>();
            mockedMadiator.Setup(m => m.Publish(It.IsAny<OperationFinishedNotification>(), It.IsAny<CancellationToken>()))
                .Returns(Task.CompletedTask)
                .Verifiable(Times.Once());

            var mockedLogger = new Mock<ILogger<MultiOperationRunner>>();

            var mockedOptions = new Mock<IOptions<ProcessingOptions>>();
            mockedOptions.Setup(o => o.Value).Returns(new ProcessingOptions() { StorageDirectory = "" });

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object,
                mockedDownloadExecutor.Object, mockedSettingsGenerator.Object, mockedUploadExecutor.Object, mockedCleanExecutor.Object);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
        }
    }
}
