using VirtualTourAPI.Client;
using VirtualTourAPI.Client.Parameters;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class UploadExecutor : IOperationExecutor
    {
        private readonly VTClient _vtClient;

        public UploadExecutor(VTClient vtClient)
        {
            _vtClient = vtClient;
        }

        public async Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            var outputDirectory = Path.Combine(parameters.AreaDirectory, "renders");
            var files = Directory.GetFiles(outputDirectory);

            try
            {
                foreach (var file in files)
                {
                    var createSceneParameters = new CreateSceneParameters()
                    {
                        TourId = parameters.Operation.TourId,
                        ParentId = parameters.Operation.AreaId
                    };

                    var result = await _vtClient.Service.CreateScene(createSceneParameters);

                    var addPhotoParameters = new AddPhotoToSceneParameters()
                    {
                        TourId = parameters.Operation.TourId,
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
