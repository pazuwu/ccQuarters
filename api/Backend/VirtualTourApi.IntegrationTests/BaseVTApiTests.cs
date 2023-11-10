using Microsoft.Extensions.Configuration;
using VirtualTourAPI.ServiceClient;

namespace VirtualTourApi.IntegrationTests
{
    public abstract class BaseVTApiTests
    {
        protected static IVTService _service;
        private static readonly string _baseUrl;
        private const string _token = "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ0OWU0N2ZiZGQ0ZWUyNDE0Nzk2ZDhlMDhjZWY2YjU1ZDA3MDRlNGQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY2NxdWFydGVyc21pbmkiLCJhdWQiOiJjY3F1YXJ0ZXJzbWluaSIsImF1dGhfdGltZSI6MTY5OTU3MjIzMywidXNlcl9pZCI6IjI0RXNmWEJYc0hjc2pMOHJCcHhlS2dQOFRNWjIiLCJzdWIiOiIyNEVzZlhCWHNIY3NqTDhyQnB4ZUtnUDhUTVoyIiwiaWF0IjoxNjk5NTcyMjMzLCJleHAiOjE2OTk1NzU4MzMsImVtYWlsIjoidnRAdGVzdC5wbCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ2dEB0ZXN0LnBsIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.g3EePilRSy3_NGlWU03XNgXe2c_GFoLXcKaP-6t5rRykVTb7y4XV-dtSqb1gLE8ucP2f7UeVp1JFbL9jq2X4Qg7NiX9HfRcbshPjkrzkPuisE73kTeGYib8nlFqe9x7t2fyJP7OgEgiOu_LoYk3uxgEgv0SBRA81S5GAssFB6kpOJRtIiA_o11jOKeqNwOXyiITcL2fj8mDXGifRbrr4T8VwJubp57cKrpZrusraB5iK3Ei87h8wWzS5QEiulQQdqUj5rdmuj4pGkd4B1bejLirguISx8PZDipUqowlWmcgsobQ-i5gzIe9UyvPfq6rP64aupZgFMKtkpU_7LD5mBg";

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
