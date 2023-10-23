namespace CCQuartersAPI.Endpoints
{
    public static class UsersEndpoints
    {
        public static void MapUsersEndpoints(this WebApplication app)
        {
            app.MapPost("/users", CreateUser);
            app.MapGet("/users/{userId}", GetUser);
            app.MapPut("/users/{userId}", UpdateUser);
            app.MapPut("/users/{userId}/delete", DeleteUser);
            app.MapPost("/users/{userId}/photo", AddPhoto);
        }

        private static Task CreateUser(HttpContext context) 
        {
            throw new NotImplementedException();
        }
        private static Task GetUser(HttpContext context) 
        {
            throw new NotImplementedException();
        }
        private static Task UpdateUser(HttpContext context) 
        {
            throw new NotImplementedException();
        }
        private static Task DeleteUser(HttpContext context) 
        {
            throw new NotImplementedException();
        }
        private static Task AddPhoto(HttpContext context) 
        {
            throw new NotImplementedException();
        }
    }
}
