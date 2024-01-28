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
        public async Task MultiOperationRunnerRunsDownload()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Waiting);

            var mockedDownloadExecutor = CreateExecutorMock(Times.Once());
            var mockedSettingsGenerator = CreateExecutorMock(Times.Never());
            var mockedUploadExecutor = CreateExecutorMock(Times.Never());
            var mockedCleanExecutor = CreateExecutorMock(Times.Never());

            var mockedMadiator = CreateMediatorMock();
            var mockedLogger = CreateLoggerMock();
            var mockedOptions = CreateOptionsMock();
            MultiExecutorResolver resolver = operationStage => operationStage switch
            {
                OperationStage.Waiting => mockedDownloadExecutor.Object,
                OperationStage.PrepareRender => mockedSettingsGenerator.Object,
                OperationStage.SavingRender => mockedUploadExecutor.Object,
                OperationStage.Finished => mockedCleanExecutor.Object,
                _ => null,
            };

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object, resolver);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            await Task.Delay(TimeSpan.FromSeconds(1));

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
        }

        [TestMethod]
        public async Task MultiOperationRunnerRunsPrepareRender()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.PrepareRender);

            var mockedDownloadExecutor = CreateExecutorMock(Times.Never());
            var mockedSettingsGenerator = CreateExecutorMock(Times.Once());
            var mockedUploadExecutor = CreateExecutorMock(Times.Never());
            var mockedCleanExecutor = CreateExecutorMock(Times.Never());

            var mockedMadiator = CreateMediatorMock();
            var mockedLogger = CreateLoggerMock();
            var mockedOptions = CreateOptionsMock();
            MultiExecutorResolver resolver = operationStage => operationStage switch
            {
                OperationStage.Waiting => mockedDownloadExecutor.Object,
                OperationStage.PrepareRender => mockedSettingsGenerator.Object,
                OperationStage.SavingRender => mockedUploadExecutor.Object,
                OperationStage.Finished => mockedCleanExecutor.Object,
                _ => null,
            };

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object, resolver);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            await Task.Delay(TimeSpan.FromSeconds(1));

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
        }

        [TestMethod]
        public async Task MultiOperationRunnerRunsSavingRender()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.SavingRender);

            var mockedDownloadExecutor = CreateExecutorMock(Times.Never());
            var mockedSettingsGenerator = CreateExecutorMock(Times.Never());
            var mockedUploadExecutor = CreateExecutorMock(Times.Once());
            var mockedCleanExecutor = CreateExecutorMock(Times.Never());

            var mockedMadiator = CreateMediatorMock();
            var mockedLogger = CreateLoggerMock();
            var mockedOptions = CreateOptionsMock();
            MultiExecutorResolver resolver = operationStage => operationStage switch
            {
                OperationStage.Waiting => mockedDownloadExecutor.Object,
                OperationStage.PrepareRender => mockedSettingsGenerator.Object,
                OperationStage.SavingRender => mockedUploadExecutor.Object,
                OperationStage.Finished => mockedCleanExecutor.Object,
                _ => null,
            };

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object, resolver);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            await Task.Delay(TimeSpan.FromSeconds(1));

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
        }

        [TestMethod]
        public async Task MultiOperationRunnerRunsCleaning()
        {
            var colmapStageOperation = OperationsFactory.CreateOperation(OperationStage.Finished);

            var mockedDownloadExecutor = CreateExecutorMock(Times.Never());
            var mockedSettingsGenerator = CreateExecutorMock(Times.Never());
            var mockedUploadExecutor = CreateExecutorMock(Times.Never());
            var mockedCleanExecutor = CreateExecutorMock(Times.Once());

            var mockedMadiator = CreateMediatorMock();
            var mockedLogger = CreateLoggerMock();
            var mockedOptions = CreateOptionsMock();
            MultiExecutorResolver resolver = operationStage => operationStage switch
            {
                OperationStage.Waiting => mockedDownloadExecutor.Object,
                OperationStage.PrepareRender => mockedSettingsGenerator.Object,
                OperationStage.SavingRender => mockedUploadExecutor.Object,
                OperationStage.Finished => mockedCleanExecutor.Object,
                _ => null,
            };

            var operationRunner = new MultiOperationRunner(mockedLogger.Object, mockedOptions.Object, mockedMadiator.Object, resolver);

            operationRunner.TryRegister(colmapStageOperation).Should().Be(true);
            operationRunner.Run(colmapStageOperation);

            await Task.Delay(TimeSpan.FromSeconds(1));

            Mock.Verify(mockedDownloadExecutor, mockedSettingsGenerator, mockedUploadExecutor, mockedCleanExecutor, mockedMadiator);
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

        private Mock<ILogger<MultiOperationRunner>> CreateLoggerMock()
        {
            return new Mock<ILogger<MultiOperationRunner>>();
        }
    }
}
