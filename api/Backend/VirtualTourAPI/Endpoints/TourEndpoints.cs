using CloudStorageLibrary;
using VirtualTourAPI.Repository;

namespace VirtualTourAPI.Endpoints
{
    public static class TourEndpoints
    {
        public static async Task<IResult> Get(string tourId, IVTRepository repository, IStorage storage)
        {
            var tour = await repository.GetTour(tourId);

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
    }
}
