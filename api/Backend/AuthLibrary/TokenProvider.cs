using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Firebase.Auth;
using Firebase.Auth.Providers;

namespace AuthLibrary
{
    public class TokenProvider : ITokenProvider
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public TokenProvider(IHttpContextAccessor httpContextAccessor, IConfiguration configuration)
        {
            _httpContextAccessor = httpContextAccessor;
            _configuration = configuration;
        }

        public async Task<string> GetUserToken()
        {
            if (_httpContextAccessor.HttpContext != null)
                return await _httpContextAccessor.HttpContext.GetTokenAsync("access_token") ?? string.Empty;

            return string.Empty;
        }

        public async Task<string> GetServerToken()
        {
            try
            {
                var client = new FirebaseAuthClient(new FirebaseAuthConfig()
                {
                    ApiKey = _configuration["Fireauth:ApiKey"],
                    AuthDomain = _configuration["Fireauth:AuthDomain"],
                    Providers = new FirebaseAuthProvider[]
                    {
                        new EmailProvider()
                    }
                });

                var credentials = await client.SignInWithEmailAndPasswordAsync(_configuration["Fireauth:Login"], _configuration["Fireauth:Password"]);

                return await credentials.User.GetIdTokenAsync();
            }
            catch 
            {
                return string.Empty;
            }
        }

    }
}
