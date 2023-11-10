﻿using System.Collections.Concurrent;
using VirtualTourAPI.Model;
using VirtualTourAPI.Repository;

namespace VirtualTourApi.IntegrationTests.Mocks
{
    internal class VTRepositoryMock : IVTRepository
    {
        private ConcurrentDictionary<string, TourDTO> _tours = new();

        public Task<string?> CreateArea(string tourId, AreaDTO area)
        {
            if(_tours.TryGetValue(tourId, out var tour))
            {
                area.Id = Guid.NewGuid().ToString();
                tour.Areas ??= new();
                tour.Areas.Add(area);
                return Task.FromResult<string?>(area.Id);
            }

            return Task.FromResult<string?>(null);
        }

        public Task<string?> CreateLink(string tourId, LinkDTO link)
        {
            if (_tours.TryGetValue(tourId, out var tour))
            {
                link.Id = Guid.NewGuid().ToString();
                tour.Links ??= new();
                tour.Links.Add(link);
                return Task.FromResult<string?>(link.Id);
            }

            return Task.FromResult<string?>(null);
        }

        public Task<string?> CreateOperation(string tourId, string areaId)
        {
            var id = Guid.NewGuid().ToString();
            return Task.FromResult<string?>(id);
        }

        public Task<string?> CreateScene(string tourId, SceneDTO scene)
        {
            if (_tours.TryGetValue(tourId, out var tour))
            {
                scene.Id = Guid.NewGuid().ToString();
                tour.Scenes ??= new();
                tour.Scenes.Add(scene);
                return Task.FromResult<string?>(scene.Id);
            }

            return Task.FromResult<string?>(null);
        }

        public Task<string?> CreateTour()
        {
            var tour = new TourDTO()
            {
                Id = Guid.NewGuid().ToString()
            };

            _tours.TryAdd(tour.Id, tour);
            return Task.FromResult<string?>(tour.Id);
        }

        public Task DeleteArea(string tourId, string areaId)
        {
            if (_tours.TryGetValue(tourId, out var tour))
            {
                tour.Areas?.RemoveAll(a => a.Id == areaId);
            }

            return Task.CompletedTask;
        }

        public Task DeleteLink(string tourId, string linkId)
        {
            if (_tours.TryGetValue(tourId, out var tour))
            {
                tour.Areas?.RemoveAll(a => a.Id == linkId);
            }

            return Task.CompletedTask;
        }

        public Task DeleteScene(string tourId, string sceneId)
        {
            if (_tours.TryGetValue(tourId, out var tour))
            {
                tour.Scenes?.RemoveAll(a => a.Id == sceneId);
            }

            return Task.CompletedTask;
        }

        public Task DeleteTour(string tourId)
        {
            _tours.Remove(tourId, out _);

            return Task.CompletedTask;
        }

        public Task<TourDTO?> GetTour(string tourId)
        {
            _tours.TryGetValue(tourId, out var tour);
            return Task.FromResult(tour);
        }

        public Task UpdateLink(string tourId, LinkDTO link)
        {
            if (_tours.TryGetValue(tourId, out var tour))
            {
                var linkToChange = tour.Links?.FirstOrDefault(a => a.Id == link.Id);

                if (linkToChange == null)
                    return Task.CompletedTask;

                linkToChange.Text = link.Text ?? linkToChange.Text;
                linkToChange.DestinationId = link.DestinationId ?? linkToChange.DestinationId;
                linkToChange.NextOrientation = link.NextOrientation ?? linkToChange.NextOrientation;
                linkToChange.Position = link.Position ?? linkToChange.Position;
            }

            return Task.CompletedTask;
        }
    }
}