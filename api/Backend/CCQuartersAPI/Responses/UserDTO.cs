using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class UserDTO
    {
        public string Id { get; set; }
        public string? Name { get; set; }
        public string? Surname { get; set; }
        public string? Company { get; set; }
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string? PhotoUrl { get; set; }
    }
}
