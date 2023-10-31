
using CCQuartersAPI.Endpoints;
using CloudStorageLibrary;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.OpenApi.Models;

namespace CCQuartersAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddAuthorization(o =>
            {
                o.AddPolicy("Auth", p => p.
                    RequireAuthenticatedUser());
            });

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen(c =>
            {
                //c.SwaggerDoc("1.0", new OpenApiInfo
                //{
                //    Title = "ccQuartersAPI",
                //    Version = "1.0"
                //});
                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
                {
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer",
                    BearerFormat = "JWT",
                    In = ParameterLocation.Header,
                    Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 1safsfsdfdfd\"",
                });
                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme {
                            Reference = new OpenApiReference {
                                Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                            }
                        },
                        new string[] {}
                    }
                });
            });

            builder.Services.AddAuthentication(opt =>
            {
                opt.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
            })
                .AddJwtBearer(opt =>
                {
                    opt.Authority = builder.Configuration["Jwt:Firebase:ValidIssuer"];
                    opt.Audience = builder.Configuration["Jwt:Firebase:ValidAudience"];
                    opt.TokenValidationParameters.ValidIssuer = builder.Configuration["Jwt:Firebase:ValidIssuer"];
                    //opt.TokenValidationParameters.ValidAudience = builder.Configuration["Jwt:Firebase:ValidAudience"];
                });

            builder.Services.AddCors();

            builder.Services.AddSingleton(typeof(IStorage), typeof(FirebaseCloudStorage));

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

            app.MapGet("/houses", HousesEndpoints.GetHouses).WithOpenApi().RequireAuthorization("Auth");
            app.MapGet("/houses/liked", HousesEndpoints.GetLikedHouses).WithOpenApi().RequireAuthorization("Auth");
            app.MapPost("/houses", HousesEndpoints.CreateHouse).WithOpenApi().RequireAuthorization("Auth");
            app.MapGet("/houses/{houseId}", HousesEndpoints.GetHouse).WithOpenApi().RequireAuthorization("Auth");
            app.MapPut("/houses/{houseId}", HousesEndpoints.UpdateHouse).WithOpenApi().RequireAuthorization("Auth");
            app.MapPut("/houses/{houseId}/delete", HousesEndpoints.DeleteHouse).WithOpenApi().RequireAuthorization("Auth");
            app.MapPut("/houses/{houseId}/like", HousesEndpoints.LikeHouse).WithOpenApi().RequireAuthorization("Auth");
            app.MapPut("/houses/{houseId}/unlike", HousesEndpoints.UnlikeHouse).WithOpenApi().RequireAuthorization("Auth");
            app.MapPost("/houses/{houseId}/photos", HousesEndpoints.AddPhoto).WithOpenApi().RequireAuthorization("Auth");

            app.MapGet("/alerts", AlertsEndpoints.GetAlerts).WithOpenApi().RequireAuthorization("Auth");
            app.MapPost("/alerts", AlertsEndpoints.CreateAlert).WithOpenApi().RequireAuthorization("Auth");
            app.MapPut("/alerts/{alertId}", AlertsEndpoints.UpdateAlert).WithOpenApi().RequireAuthorization("Auth");
            app.MapDelete("/alerts/{alertId}/delete", AlertsEndpoints.DeleteAlert).WithOpenApi().RequireAuthorization("Auth");

            app.Run();
        }
    }
}