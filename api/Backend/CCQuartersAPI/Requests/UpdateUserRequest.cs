using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Requests
{
    public class UpdateUserRequest
    {
        public string? Name { get; set; }
        public string? Surname { get; set; }
        public string? Company { get; set; }
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
    }
}
