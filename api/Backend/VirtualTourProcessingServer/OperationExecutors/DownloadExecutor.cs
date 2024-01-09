using VirtualTourAPI.Client;
using VirtualTourAPI.Client.Parameters;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class DownloadExecutor : IOperationExecutor
    {
        private readonly VTClient _vtClient;
        private readonly IHttpClientFactory _httpFactory;

        public DownloadExecutor(IHttpClientFactory httpFactory, VTClient vtClient)
        {
            _vtClient = vtClient;
            _httpFactory = httpFactory;
        }

        public async Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            var outputDirectory = Path.Combine(parameters.AreaDirectory, "download");

            try
            {
                if (!Directory.Exists(outputDirectory))
                    Directory.CreateDirectory(outputDirectory);

                var getAreaPhotosparameters = new GetAreaPhotosParameters()
                {
                    TourId = parameters.Operation.TourId,
                    AreaId = parameters.Operation.AreaId,
                };
                var res = await _vtClient.Service.GetAreaPhotos(getAreaPhotosparameters);

                if (res.PhotoUrls == null)
                    return ExecutorResponse.Problem("Get area photos returned empty collection of urls");

                var downloadTasks = new List<Task<DownloadStatus>>();
                foreach (var photoUrl in res.PhotoUrls)
                {
                    downloadTasks.Add(DownloadAndSavePhoto(photoUrl, outputDirectory));
                }

                await Task.WhenAll(downloadTasks);

                foreach (var task in downloadTasks)
                {
                    var status = task.GetAwaiter().GetResult();

                    if (status != DownloadStatus.Ok)
                        return ExecutorResponse.Problem("Some files weren't downloaded.");
                }
            }
            catch (Exception ex)
            {
                return ExecutorResponse.Problem(ex.Message);
            }

            return ExecutorResponse.Ok();
        }

        private async Task<DownloadStatus> DownloadAndSavePhoto(string photoUrl, string outputDirectory)
        {
            var photoPath = Path.Combine(outputDirectory, Guid.NewGuid().ToString());
            photoPath = Path.ChangeExtension(photoPath, "png");

            if (File.Exists(photoPath))
                return DownloadStatus.Ok;

            try
            {
                using var httpClient = _httpFactory.CreateClient();
                var photoBytes = await httpClient.GetByteArrayAsync(photoUrl);
                File.WriteAllBytes(photoPath, photoBytes);
            }
            catch
            {
                return DownloadStatus.Failed;
            }

            return DownloadStatus.Ok;
        }

        private enum DownloadStatus
        {
            Ok,
            Failed,
        }
    }
}
