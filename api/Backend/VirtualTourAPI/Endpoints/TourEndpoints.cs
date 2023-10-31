using VirtualTourAPI.Repository;

namespace VirtualTourAPI.Endpoints
{
    public static class TourEndpoints
    {
        public static async Task<IResult> Get(string tourId, IVTRepository repository)
        {
            var tour = await repository.GetTour(tourId);

            if(tour == null)
                return Results.NotFound();

            return Results.Ok(tour);
        }
    }
}
