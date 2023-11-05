using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace AuthLibrary
{
    public static class FirebaseAuthenitcationExtentions
    {
        public static void AddFirebaseAuthorizarion(this WebApplicationBuilder builder)
        {
            builder.Services.AddAuthorization(o =>
            {
                o.AddPolicy("Auth", p => p.
                    RequireAuthenticatedUser());
            });
        }

        public static void AddFirebaseAuthentication(this WebApplicationBuilder builder)
        {
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

        }

        public static void AddFirebaseSecurityDefinition(this SwaggerGenOptions options)
        {
            options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
            {
                Name = "Authorization",
                Type = SecuritySchemeType.ApiKey,
                Scheme = "Bearer",
                BearerFormat = "JWT",
                In = ParameterLocation.Header,
                Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 1safsfsdfdfd\"",
            });

            options.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme {
                            Reference = new OpenApiReference {
                                Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                            }
                        },
                        Array.Empty<string>()
                    }
                });
        }

        public static IEndpointConventionBuilder RequireFBAuthorization(this IEndpointConventionBuilder builder)
        {
            builder.RequireAuthorization("Auth");
            return builder;
        }
        
        public static RouteHandlerBuilder RequireFBAuthorization(this RouteHandlerBuilder builder)
        {
            builder.RequireAuthorization("Auth");
            return builder;
        }
    }
}
