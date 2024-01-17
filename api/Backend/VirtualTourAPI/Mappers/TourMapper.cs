using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Model;

namespace VirtualTourAPI.Mappers
{
    public static class TourMapper
    {
        public static TourDBO Map(this TourForEditDTO tour)
        {
            return new TourDBO
            {
                Id = tour.Id,
                Name = tour.Name,
                OwnerId = tour.OwnerId,
                PrimarySceneId = tour.PrimarySceneId,
            };
        }

        public static NewTourDBO Map(this NewTourDTO tour)
        {
            return new NewTourDBO()
            {
                Name = tour.Name,
                OwnerId = tour.OwnerId,
                PrimarySceneId = tour.PrimarySceneId,
            };
        } 

        public static TourInfoDTO Map(this TourInfoDBO tour)
        {
            return new TourInfoDTO()
            {
                Name = tour.Name,
                Id = tour.Id,
            };
        }
    }
}
