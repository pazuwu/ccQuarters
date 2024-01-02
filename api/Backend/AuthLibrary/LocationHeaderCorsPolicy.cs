using Microsoft.AspNetCore.Cors.Infrastructure;
using Microsoft.Net.Http.Headers;

namespace AuthLibrary
{
    public static class LocationHeaderCorsPolicy
    {
        public const string LocationPolicyName = "LocationHeaderCors";

        public static void AddLocationHeaderCorsOptions(this CorsOptions options)
        {
            options.AddPolicy(LocationPolicyName, policy => policy
            .AllowAnyOrigin()
            .WithExposedHeaders(HeaderNames.Location));
        }
    }
}
