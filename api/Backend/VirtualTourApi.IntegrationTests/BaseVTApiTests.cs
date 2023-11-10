using Microsoft.Extensions.Configuration;
using VirtualTourAPI.ServiceClient;

namespace VirtualTourApi.IntegrationTests
{
    public abstract class BaseVTApiTests
    {
        protected static IVTService _service;
        private static readonly string _baseUrl;
        private const string _token = "Bearer ";

        static BaseVTApiTests()
        {
            var config = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();
            var vtApiUrl = config["VTApiUrl"];

            if (string.IsNullOrWhiteSpace(vtApiUrl))
                throw new Exception("VTApiUrl is empty. Check your tests configuration file");

            _baseUrl = vtApiUrl;

            var httpClient = new HttpClient();
            httpClient.BaseAddress = new Uri(_baseUrl);
            httpClient.DefaultRequestHeaders.Add("Authorization", _token);

            _service = new VTClient(httpClient).Service;
        }
    }
}
