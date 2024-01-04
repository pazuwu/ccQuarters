using Google.Cloud.Firestore;

namespace VirtualTourAPI.DTOModel
{
    public class GeoPointDTO
    {
        public double Longitude { get; }
        public double Latitude { get; }

        public GeoPointDTO(double latitude, double longitude)
        {
            Latitude = latitude;
            Longitude = longitude;
        }
    }

    public static class GeoPointExtensions
    {
        public static GeoPoint? MapToDBGeoPoint(this GeoPointDTO? geoPoint)
        {
            return geoPoint != null
                ? new GeoPoint(geoPoint.Latitude, geoPoint.Longitude)
                : null;
        }

        public static GeoPointDTO? MapToDTOGeoPoint(this GeoPoint? geoPoint)
        {
            return geoPoint.HasValue
                ? new GeoPointDTO(geoPoint.Value.Latitude, geoPoint.Value.Longitude)
                : null;
        }
    }
}
