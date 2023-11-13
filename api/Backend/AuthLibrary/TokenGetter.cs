using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Firebase.Auth;
using Firebase.Auth.Providers;
using FirebaseAdmin;
using FirebaseAdmin.Auth;
using Google.Apis.Auth.OAuth2;

namespace AuthLibrary
{
    public class TokenGetter : ITokenGetter
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IConfiguration _configuration;

        public TokenGetter(IHttpContextAccessor httpContextAccessor, IConfiguration configuration)
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
