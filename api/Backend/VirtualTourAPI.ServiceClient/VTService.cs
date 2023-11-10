using System.Net.Http.Json;
using VirtualTourAPI.Client.Parameters;
using VirtualTourAPI.ServiceClient.Model;
using VirtualTourAPI.ServiceClient.Parameters;
using VirtualTourAPI.ServiceClient.Requests;
using VirtualTourAPI.ServiceClient.Results;

namespace VirtualTourAPI.ServiceClient
{
    internal class VTService : IVTService
    {
        private readonly HttpClient _http;

        public VTService(HttpClient http)
        {
            _http = http;
        }

        public Task<AddPhotoToAreaResult> AddPhotoToArea(AddPhotoToAreaParameters parameters)
        {
            throw new NotImplementedException();
        }

        public Task<AddPhotoToSceneResult> AddPhotoToScene(AddPhotoToSceneParameters parameters)
        {
            throw new NotImplementedException();
        }

        public Task<CreateAreaResult> CreateArea(CreateAreaParameters parameters)
        {
            throw new NotImplementedException();
        }

        public Task<CreateLinkResult> CreateLink(CreateLinkParameters parameters)
        {
            throw new NotImplementedException();
        }

        public async Task<CreateSceneResult> CreateScene(CreateSceneParameters parameters)
        {
            var request = new PostSceneRequest()
            {
                ParentId = parameters.ParentId,
            };

            var response = await _http.PostAsync($"tours/{parameters.TourId}/scenes", JsonContent.Create(request));

            response.EnsureSuccessStatusCode();
            var sceneId = response.Headers?.Location?.OriginalString;

            return new()
            {
                Scene = new SceneDTO()
                {
                    Id = sceneId,
                },
            };
        }

        public async Task<CreateTourResult> CreateTour(CreateTourParameters parameters)
        {
            var response = await _http.PostAsync("tours", null);

            response.EnsureSuccessStatusCode();
            var tourid = response.Headers?.Location?.OriginalString;

            return new()
            {
                Tour = new TourDTO()
                {
                    Id = tourid,
                },
            };
        }

        public async Task<DeleteTourResult> DeleteTour(DeleteTourParameters parameters)
        {
            var response = await _http.DeleteAsync($"tours/{parameters.TourId}");

            response.EnsureSuccessStatusCode();
            return new();
        }

        public Task<DeleteAreaResult> DeleteArea(DeleteAreaParameters parameters)
        {
            throw new NotImplementedException();
        }

        public Task<CreateLinkResult> DeleteLink(CreateLinkParameters parameters)
        {
            throw new NotImplementedException();
        }

        public async Task<DeleteSceneResult> DeleteScene(DeleteSceneParameters parameters)
        {
            var response = await _http.DeleteAsync($"tours/{parameters.TourId}/scenes/{parameters.SceneId}");

            response.EnsureSuccessStatusCode();
            return new();
        }

        public Task<GetTourResult> GetTourById(GetTourParameters parameters)
        {
            throw new NotImplementedException();
        }

        public Task<UpdateLinkResult> UpdateLink(UpdateLinkParameters parameters)
        {
            throw new NotImplementedException();
        }
    }
}
