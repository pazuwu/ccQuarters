using AuthLibrary;
using CCQuartersAPI.Endpoints;
using CCQuartersAPI.Services;
using CloudStorageLibrary;
using RepositoryLibrary;

namespace CCQuartersAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.AddFirebaseAuthorizarion();
            builder.AddFirebaseAuthentication();
            builder.Services.AddCors(c => c.AddLocationHeaderCorsOptions());

            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen(c => c.AddFirebaseSecurityDefinition());

            builder.Services.AddHttpContextAccessor();
            builder.Services.AddTransient<ITokenProvider, TokenProvider>();
            builder.Services.AddTransient<IStorage, FirebaseCloudStorage>();
            builder.Services.AddScoped<IRelationalDBRepository, RelationalDBRepository>();
            builder.Services.AddScoped<IDocumentDBRepository, DocumentDBRepository>();
            builder.Services.AddScoped<IUsersService, UsersService>();
            builder.Services.AddScoped<IAlertsService, AlertsService>();
            builder.Services.AddScoped<IHousePhotosService, HousePhotosService>();
            builder.Services.AddScoped<IHousesService, HousesService>();

            var app = builder.Build();

            app.UseCors(options => options.AllowAnyMethod().
                               AllowAnyHeader().
                               SetIsOriginAllowed(_ => true).
                               AllowCredentials());

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseCors(LocationHeaderCorsPolicy.LocationPolicyName);

            app.MapGet("/houses", HousesEndpoints.GetHouses).WithOpenApi().RequireFBAuthorization();
            app.MapGet("/houses/liked", HousesEndpoints.GetLikedHouses).WithOpenApi().RequireFBAuthorization();
            app.MapGet("/houses/my", HousesEndpoints.GetMyHouses).WithOpenApi().RequireFBAuthorization();
            app.MapPost("/houses", HousesEndpoints.CreateHouse).WithOpenApi().RequireFBAuthorization();
            app.MapGet("/houses/{houseId}", HousesEndpoints.GetHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}", HousesEndpoints.UpdateHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}/delete", HousesEndpoints.DeleteHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}/like", HousesEndpoints.LikeHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}/unlike", HousesEndpoints.UnlikeHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPost("/houses/{houseId}/photo", HousesEndpoints.AddPhoto).WithOpenApi().RequireFBAuthorization();
            app.MapDelete("/houses/photos", HousesEndpoints.DeletePhotos).WithOpenApi().RequireFBAuthorization();

            app.MapGet("/alerts", AlertsEndpoints.GetAlerts).WithOpenApi().RequireFBAuthorization();
            app.MapPost("/alerts", AlertsEndpoints.CreateAlert).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/alerts/{alertId}", AlertsEndpoints.UpdateAlert).WithOpenApi().RequireFBAuthorization();
            app.MapDelete("/alerts/{alertId}", AlertsEndpoints.DeleteAlert).WithOpenApi().RequireFBAuthorization();

            app.MapGet("/users/{userId}", UsersEndpoints.GetUser);
            app.MapPut("/users/{userId}", UsersEndpoints.UpdateUser);
            app.MapPut("/users/{userId}/delete", UsersEndpoints.DeleteUser);
            app.MapPost("/users/{userId}/photo", UsersEndpoints.ChangePhoto);
            app.MapPut("/users/{userId}/photo/delete", UsersEndpoints.DeletePhoto);

            app.Run();
        }
    }
}