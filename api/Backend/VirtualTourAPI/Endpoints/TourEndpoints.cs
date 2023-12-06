using CloudStorageLibrary;
using VirtualTourAPI.Service;

namespace VirtualTourAPI.Endpoints
{
    public static class TourEndpoints
    {
        public static async Task<IResult> Get(string tourId, IVTService service, IStorage storage)
        {
            var tour = await service.GetTour(tourId);

            if (tour == null)
                return Results.NotFound();

            if(tour.Scenes != null)
            {
                foreach (var scene in tour.Scenes)
                {
                    if(scene.Id != null)
                        scene.Photo360Url = await storage.GetDownloadUrl($"tours/{tourId}/scenes", scene.Id);
                }
            }

            return Results.Ok(tour);
        }

        public static async Task<IResult> Post(IVTService service)
        {
            var tourId = await service.CreateTour();

            if (tourId == null)
                return Results.Problem("An error occured while creating new tour in database");

            return Results.Created(tourId, null);
        }

        public static async Task<IResult> Delete(string tourId, IVTService service)
        {
            await service.DeleteTour(tourId);
            return Results.Ok();
        }
    }
}
