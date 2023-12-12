
namespace VirtualTourAPI.Client.Model
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
}
