﻿using System.Net.Http.Json;
using VirtualTourAPI.Client.Parameters;
using VirtualTourAPI.Client.Model;
using VirtualTourAPI.Client.Requests;
using VirtualTourAPI.Client.Results;

namespace VirtualTourAPI.Client
{
    internal class VTService : IVTService
    {
        private readonly HttpClient _http;

        public VTService(HttpClient http)
        {
            _http = http;
        }

        public async Task<AddPhotoToAreaResult> AddPhotoToArea(AddPhotoToAreaParameters parameters)
        {
            using Stream stream = parameters.PhotoPath != null
                ? File.OpenRead(parameters.PhotoPath)
                : parameters.PhotoInBytes != null
                ? new MemoryStream(parameters.PhotoInBytes)
                : throw new ArgumentNullException();

            using var content = new MultipartFormDataContent
            {
                { new StreamContent(stream), "file", string.Empty }
            };

            var response = await _http.PostAsync($"tours/{parameters.TourId}/areas/{parameters.AreaId}", content);

            response.EnsureSuccessStatusCode();

            return new();
        }

        public async Task<AddPhotoToSceneResult> AddPhotoToScene(AddPhotoToSceneParameters parameters)
        {
            using Stream stream = parameters.PhotoPath != null
                ? File.OpenRead(parameters.PhotoPath)
                : parameters.PhotoInBytes != null
                ? new MemoryStream(parameters.PhotoInBytes)
                : throw new ArgumentNullException();

            using var content = new MultipartFormDataContent
            {
                { new StreamContent(stream), "file", "file" }
            };

            var response = await _http.PostAsync($"tours/{parameters.TourId}/scenes/{parameters.SceneId}/photo", content);

            response.EnsureSuccessStatusCode();

            return new();
        }

        public async Task<CreateAreaResult> CreateArea(CreateAreaParameters parameters)
        {
            var request = new PostAreaRequest()
            {
                Name = parameters.Name
            };

            var response = await _http.PostAsJsonAsync($"tours/{parameters.TourId}/areas", request);

            response.EnsureSuccessStatusCode();
            var sceneId = response.Headers?.Location?.OriginalString;

            return new()
            {
                Area = new AreaDTO()
                {
                    Id = sceneId,
                    Name = parameters.Name
                },
            };
        }

        public async Task<CreateLinkResult> CreateLink(CreateLinkParameters parameters)
        {
            var request = new PostLinkRequest()
            {
                DestinationId = parameters.DestinationId,
                Latitude = parameters.Position?.Latitude,
                Longitude = parameters.Position?.Longitude,
                NextOrientation = parameters.NextOrientation,
                ParentId = parameters.ParentId,
                Text = parameters.Text
            };

            var response = await _http.PostAsJsonAsync($"tours/{parameters.TourId}/links", request);

            response.EnsureSuccessStatusCode();
            var sceneId = response.Headers?.Location?.OriginalString;

            return new()
            {
                Link = new LinkDTO()
                {
                    Id = sceneId,
                    Text = parameters.Text,
                    DestinationId = parameters.DestinationId,
                    ParentId = parameters.ParentId,
                    NextOrientation = parameters.NextOrientation,
                    Position = parameters.Position,
                },
            };
        }

        public async Task<CreateSceneResult> CreateScene(CreateSceneParameters parameters)
        {
            var request = new PostSceneRequest()
            {
                Name = parameters.Name,
                ParentId = parameters.ParentId,
            };

            var response = await _http.PostAsJsonAsync($"tours/{parameters.TourId}/scenes", request);

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

        public async Task<DeleteAreaResult> DeleteArea(DeleteAreaParameters parameters)
        {
            var response = await _http.DeleteAsync($"tours/{parameters.TourId}/areas/{parameters.AreaId}");

            response.EnsureSuccessStatusCode();
            return new();
        }

        public async Task<DeleteLinkResult> DeleteLink(DeleteLinkParameters parameters)
        {
            var response = await _http.DeleteAsync($"tours/{parameters.TourId}/links/{parameters.LinkId}");

            response.EnsureSuccessStatusCode();
            return new();
        }

        public async Task<DeleteSceneResult> DeleteScene(DeleteSceneParameters parameters)
        {
            var response = await _http.DeleteAsync($"tours/{parameters.TourId}/scenes/{parameters.SceneId}");

            response.EnsureSuccessStatusCode();
            return new();
        }

        public async Task<GetTourResult> GetTourById(GetTourParameters parameters)
        {
            try
            {
                var response = await _http.GetFromJsonAsync<TourDTO>($"tours/{parameters.TourId}");
                return new() { Tour = response };
            }
            catch (HttpRequestException ex)
            {
                if (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
                    return new();

                throw;
            }
        }

        public async Task<UpdateLinkResult> UpdateLink(UpdateLinkParameters parameters)
        {
            var request = new PutLinkRequest()
            {
                DestinationId = parameters.DestinationId,
                NextOrientation = parameters.NextOrientation,
                Text = parameters.Text,
                Position = parameters.Position,
            };

            var response = await _http.PutAsJsonAsync($"tours/{parameters.TourId}/links/{parameters.LinkId}", request);

            response.EnsureSuccessStatusCode();
            return new();
        }

        public async Task<GetAreaPhotosResult> GetAreaPhotos(GetAreaPhotosParameters parameters)
        {
            var response = await _http.GetFromJsonAsync<string[]>($"tours/{parameters.TourId}/areas/{parameters.AreaId}/photos");

            return new()
            {
                PhotoUrls = response
            };
        }

        public async Task<UpdateOperationResult> UpdateOperation(UpdateOperationParameters parameters)
        {
            var request = new PutOperationRequest()
            {
                Stage = parameters.Stage
            };

            var response = await _http.PutAsJsonAsync($"tours/{parameters.TourId}/operations/{parameters.OperationId}", request);
            response.EnsureSuccessStatusCode();

            return new();
        }

        public async Task<DeleteOperationResult> DeleteOperation(DeleteOperationParameters parameters)
        {
            var response = await _http.DeleteAsync($"tours/{parameters.TourId}/operations/{parameters.OperationId}");
            response.EnsureSuccessStatusCode();

            return new();
        }
    }
}
