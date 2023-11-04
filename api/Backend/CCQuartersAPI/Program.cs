using AuthLibrary;
using CCQuartersAPI.Endpoints;
using CloudStorageLibrary;
using Microsoft.AspNetCore.Builder;

namespace CCQuartersAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.AddFirebaseAuthorizarion();
            builder.AddFirebaseAuthentication();
            builder.Services.AddCors();

            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen(c => c.AddFirebaseSecurityDefinition());

            builder.Services.AddHttpContextAccessor();
            builder.Services.AddTransient<IStorage, FirebaseCloudStorage>();

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

            HousesEndpoints.Init(builder.Configuration["db"]!);
            AlertsEndpoints.Init(builder.Configuration["db"]!);

            app.MapGet("/houses", HousesEndpoints.GetHouses).WithOpenApi().RequireFBAuthorization();
            app.MapGet("/houses/liked", HousesEndpoints.GetLikedHouses).WithOpenApi().RequireFBAuthorization();
            app.MapPost("/houses", HousesEndpoints.CreateHouse).WithOpenApi().RequireFBAuthorization();
            app.MapGet("/houses/{houseId}", HousesEndpoints.GetHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}", HousesEndpoints.UpdateHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}/delete", HousesEndpoints.DeleteHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}/like", HousesEndpoints.LikeHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/houses/{houseId}/unlike", HousesEndpoints.UnlikeHouse).WithOpenApi().RequireFBAuthorization();
            app.MapPost("/houses/{houseId}/photos", HousesEndpoints.AddPhoto).WithOpenApi().RequireFBAuthorization();

            app.MapGet("/alerts", AlertsEndpoints.GetAlerts).WithOpenApi().RequireFBAuthorization();
            app.MapPost("/alerts", AlertsEndpoints.CreateAlert).WithOpenApi().RequireFBAuthorization();
            app.MapPut("/alerts/{alertId}", AlertsEndpoints.UpdateAlert).WithOpenApi().RequireFBAuthorization();
            app.MapDelete("/alerts/{alertId}/delete", AlertsEndpoints.DeleteAlert).WithOpenApi().RequireFBAuthorization();

            app.MapGet("/users/{userId}", UsersEndpoints.GetUser);
            app.MapPut("/users/{userId}", UsersEndpoints.UpdateUser);
            app.MapPut("/users/{userId}/delete", UsersEndpoints.DeleteUser);
            app.MapPost("/users/{userId}/photo", UsersEndpoints.ChangePhoto);

            app.Run();
        }
    }
}