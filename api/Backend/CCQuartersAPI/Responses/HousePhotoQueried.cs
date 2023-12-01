using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class HousePhotoQueried
    {
        public Guid HouseId { get; set; }
        public string UserId { get; set; }
        public string Filename { get; set; }
        public int Order { get; set; }
    }
}
