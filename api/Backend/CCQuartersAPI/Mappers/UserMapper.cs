using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using Google.Cloud.Firestore;

namespace CCQuartersAPI.Mappers
{
    public static class UserMapper
    {
        public static Dictionary<string, string> MapToDictionary(this UpdateUserRequest request)
        {
            var ret = new Dictionary<string, string>();

            if (request.Name is not null)
                ret["name"] = request.Name;
            if (request.Surname is not null)
                ret["surname"] = request.Surname;
            if (request.Company is not null)
                ret["company"] = request.Company;
            if (request.Email is not null)
                ret["email"] = request.Email;
            if (request.PhoneNumber is not null)
                ret["phoneNumber"] = request.PhoneNumber;

            return ret;
        }

        public static UserDTO MapToUserDTO(this DocumentSnapshot userDocument)
        {
            var response = new UserDTO()
            {
                Id = userDocument.Id,
                RegisterTime = userDocument.CreateTime?.ToDateTime()
            };

            if (userDocument.TryGetValue("name", out string name))
                response.Name = name;
            if (userDocument.TryGetValue("surname", out string surname))
                response.Surname = surname;
            if (userDocument.TryGetValue("company", out string company))
                response.Company = company;
            if (userDocument.TryGetValue("email", out string email))
                response.Email = email;
            if (userDocument.TryGetValue("phoneNumber", out string phoneNumber))
                response.PhoneNumber = phoneNumber;

            return response;
        }
    }
}
