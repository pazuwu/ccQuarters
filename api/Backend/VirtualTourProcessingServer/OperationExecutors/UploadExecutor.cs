using VirtualTourAPI.Client;
using VirtualTourAPI.Client.Parameters;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class UploadExecutor : IUploadExecutor
    {
        private readonly VTClient _vtClient;

        public UploadExecutor(VTClient vtClient)
        {
            _vtClient = vtClient;
        }

        public async Task<ExecutorResponse> SaveScenes(UploadExecutorParameters parameters)
        {
            var files = Directory.GetFiles(parameters.DirectoryPath);

            try
            {
                foreach (var file in files)
                {
                    var createSceneParameters = new CreateSceneParameters()
                    {
                        TourId = parameters.TourId,
                        ParentId = parameters.AreaId
                    };

                    var result = await _vtClient.Service.CreateScene(createSceneParameters);

                    var addPhotoParameters = new AddPhotoToSceneParameters()
                    {
                        TourId = parameters.TourId,
                        PhotoPath = file,
                        SceneId = result.Scene!.Id!
                    };

                    await _vtClient.Service.AddPhotoToScene(addPhotoParameters);
                }
            }
            catch (Exception)
            {
                return ExecutorResponse.Problem("Error occured while uploading scene");
            }

            return ExecutorResponse.Ok();
        }
    }
}
