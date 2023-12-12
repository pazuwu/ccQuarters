using VirtualTourAPI.Client;
using VirtualTourAPI.Client.Parameters;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class DownloadExecutor : IDownloadExecutor
    {
        private readonly VTClient _vtClient;
        private readonly IHttpClientFactory _httpFactory;

        public DownloadExecutor(IHttpClientFactory httpFactory, VTClient vtClient)
        {
            _vtClient = vtClient;
            _httpFactory = httpFactory;
        }

        public async Task<ExecutorResponse> DownloadPhotos(DownloadParameters parameters)
        {
            try
            {
                if (!Directory.Exists(parameters.OutputDirectory))
                    Directory.CreateDirectory(parameters.OutputDirectory);

                var getAreaPhotosparameters = new GetAreaPhotosParameters()
                {
                    TourId = parameters.TourId,
                    AreaId = parameters.AreaId,
                };
                var res = await _vtClient.Service.GetAreaPhotos(getAreaPhotosparameters);

                if (res.PhotoUrls == null)
                    return ExecutorResponse.Problem("Get area photos returned empty collection of urls");

                var downloadTasks = new List<Task<DownloadStatus>>();
                foreach (var photoUrl in res.PhotoUrls)
                {
                    downloadTasks.Add(DownloadAndSavePhoto(photoUrl, parameters.OutputDirectory));
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
