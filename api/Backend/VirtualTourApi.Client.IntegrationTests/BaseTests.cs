#if TEST

#else

using Microsoft.Extensions.Configuration;

namespace VirtualTourAPI.Client.IntegrationTests
{
    public abstract class BaseTests
    {
        protected static IVTService _service;
        private static readonly string _baseUrl;

        static BaseTests()
        {
            var config = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();
            var vtApiUrl = config["VTApiUrl"];

            if (string.IsNullOrWhiteSpace(vtApiUrl))
                throw new Exception("VTApiUrl is empty. Check your tests configuration file");

            _baseUrl = vtApiUrl;

            var token = config["token"];

            if (string.IsNullOrWhiteSpace(token))
                throw new Exception("token is empty. Check your tests configuration file");

            var httpClient = new HttpClient();
            httpClient.BaseAddress = new Uri(_baseUrl);
            httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}");

            _service = new VTClient(httpClient).Service;
        }
    }
}

#endif