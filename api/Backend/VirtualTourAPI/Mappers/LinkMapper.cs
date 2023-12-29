using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Mappers
{
    public static class LinkMapper
    {
        public static LinkDTO Map(this LinkDBO link)
        {
            return new()
            {
                Id = link.Id,
                DestinationId = link.DestinationId,
                ParentId = link.ParentId,
                Position = link.Position.MapToDTOGeoPoint(),
                NextOrientation = link.NextOrientation.MapToDTOGeoPoint(),
                Text = link.Text,
            };
        }

        public static NewLinkDBO Map(this NewLinkDTO link)
        {
            return new()
            {
                DestinationId = link.DestinationId,
                NextOrientation = link.NextOrientation.MapToDBGeoPoint(),
                ParentId = link.ParentId,
                Position = link.Position.MapToDBGeoPoint(),
                Text = link.Text,
            };
        }
    }
}
