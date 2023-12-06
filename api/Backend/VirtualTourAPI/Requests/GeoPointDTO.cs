using Google.Cloud.Firestore;
using System.Security.Cryptography.X509Certificates;
using static Google.Rpc.Context.AttributeContext.Types;

namespace VirtualTourAPI.Requests
{
    public class GeoPointDTO
    {
        public float Longitude { get; }
        public float Latitude { get; }

        public GeoPointDTO(float longitude, float latitude)
        {
            Longitude = longitude;
            Latitude = latitude;
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
    }
}
