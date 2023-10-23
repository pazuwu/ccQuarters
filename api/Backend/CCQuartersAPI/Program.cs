
using CCQuartersAPI.Endpoints;

namespace CCQuartersAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddAuthorization();

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();

            HousesEndpoints.Init(builder.Configuration["db"]!);
            AlertsEndpoints.Init(builder.Configuration["db"]!);

            app.MapGet("/houses", HousesEndpoints.GetHouses).WithOpenApi();
            app.MapGet("/houses/liked", HousesEndpoints.GetLikedHouses).WithOpenApi();
            app.MapPost("/houses", HousesEndpoints.CreateHouse).WithOpenApi();
            app.MapGet("/houses/{houseId}", HousesEndpoints.GetHouse).WithOpenApi();
            app.MapPut("/houses/{houseId}", HousesEndpoints.UpdateHouse).WithOpenApi();
            app.MapPut("/houses/{houseId}/delete", HousesEndpoints.DeleteHouse).WithOpenApi();
            app.MapPut("/houses/{houseId}/like", HousesEndpoints.LikeHouse).WithOpenApi();
            app.MapPut("/houses/{houseId}/unlike", HousesEndpoints.UnlikeHouse).WithOpenApi();
            app.MapPost("/houses/{houseId}/photos", HousesEndpoints.AddPhotos).WithOpenApi();

            app.MapGet("/alerts", AlertsEndpoints.GetAlerts).WithOpenApi();
            app.MapPost("/alerts", AlertsEndpoints.CreateAlert).WithOpenApi();
            app.MapPut("/alerts/{alertId}", AlertsEndpoints.UpdateAlert).WithOpenApi();
            app.MapDelete("/alerts/{alertId}/delete", AlertsEndpoints.DeleteAlert).WithOpenApi();

            app.Run();
        }
    }
}