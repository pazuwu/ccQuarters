using VirtualTourAPI.Client.Model;
using VirtualTourAPI.Client.Parameters;

#nullable disable

namespace VirtualTourAPI.Client.IntegrationTests
{
    [TestClass]
    public class ScenesTests : BaseTests
    {
        private static TourDTO _tour;

        [ClassInitialize]
        public static async Task Initialize(TestContext testContext)
        {
            CreateTourParameters parameters = new();
            var result = await _service.CreateTour(parameters);

            result.Tour.Should().NotBeNull();
            result.Tour!.Id.Should().NotBeNull();

            _tour = result.Tour;
        }

        [ClassCleanup]
        public static async Task Cleanup() 
        {
            DeleteTourParameters deleteParameters = new() { TourId = _tour!.Id! };
            await _service.DeleteTour(deleteParameters);
        }

        [TestMethod]
        public async Task CreateSceneShouldCreateScene()
        {
            CreateSceneParameters createSceneParameters = new() { TourId = _tour.Id };
            var result = await _service.CreateScene(createSceneParameters);

            result.Scene.Should().NotBeNull();
            result.Scene.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Scenes
                .Should().NotBeNull()
                .And.Subject.Should().Contain(s => s.Id == result.Scene.Id);
        }

        [TestMethod]
        public async Task DeleteSceneShouldDeleteScene()
        {
            CreateSceneParameters createSceneParameters = new() { TourId = _tour.Id };
            var result = await _service.CreateScene(createSceneParameters);

            result.Scene.Should().NotBeNull();
            result.Scene.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Scenes
                .Should().NotBeNull()
                .And.Subject.Should().Contain(s => s.Id == result.Scene.Id);

            DeleteSceneParameters deleteSceneParameters = new()
            {
                TourId = _tour.Id,
                SceneId = result.Scene.Id
            };
            await _service.DeleteScene(deleteSceneParameters);

            getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Scenes
                .Should().NotBeNull()
                .And.Subject.Should().NotContain(result.Scene);
        }

        [TestMethod]
        public async Task AddPhotoToSceneShouldAddPhoto()
        {
            CreateSceneParameters createSceneParameters = new() { TourId = _tour.Id };

            var result = await _service.CreateScene(createSceneParameters);

            result.Scene.Should().NotBeNull();
            result.Scene.Id.Should().NotBeNull();

            var addPhotoParameters = new AddPhotoToSceneParameters()
            {
                TourId = _tour.Id,
                SceneId = result.Scene.Id,
                PhotoInBytes = new byte[1000],
            };

            await _service.AddPhotoToScene(addPhotoParameters);

            GetTourParameters getTourParameters = new() { TourId = _tour.Id };

            var getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Scenes
                .Should().NotBeNull()
                .And.Subject.Should().Contain(s => s.Id == result.Scene.Id && !string.IsNullOrWhiteSpace(s.Photo360Url));
        }
    }
}
