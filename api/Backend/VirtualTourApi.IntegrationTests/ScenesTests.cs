using VirtualTourAPI.ServiceClient.Model;
using VirtualTourAPI.ServiceClient.Parameters;

#nullable disable

namespace VirtualTourApi.IntegrationTests
{
    [TestClass]
    public class ScenesTests : BaseVTApiTests
    {
        private static TourDTO _tour;

        [ClassInitialize]
        public static async Task Initialize(TestContext testContext)
        {
            var parameters = new CreateTourParameters();
            var result = await _service.CreateTour(parameters);

            result.Tour.Should().NotBeNull();
            result.Tour!.Id.Should().NotBeNull();

            _tour = result.Tour;
        }

        [ClassCleanup]
        public static async Task Cleanup() 
        {
            var deleteParameters = new DeleteTourParameters()
            {
                TourId = _tour!.Id!
            };
            await _service.DeleteTour(deleteParameters);
        }

        [TestMethod]
        public async Task CreateSceneThenDelete()
        {
            var createSceneParameters = new CreateSceneParameters()
            {
                TourId = _tour.Id,
            };

            var result = await _service.CreateScene(createSceneParameters);

            result.Scene.Should().NotBeNull();
            result.Scene.Id.Should().NotBeNull();

            var deleteSceneParameters = new DeleteSceneParameters() 
            { 
                TourId = _tour.Id,
                SceneId = result.Scene.Id 
            };
            await _service.DeleteScene(deleteSceneParameters);
        }
    }
}
