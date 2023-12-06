#nullable disable

using FluentAssertions;
using VirtualTourAPI.Model;

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceSceneTests : BaseVTServiceTests
    {
        private static string _tourId;

        [ClassInitialize]
        public static async Task Initialize(TestContext testContext)
        {
            _tourId = await _service.CreateTour();
            _tourId.Should().NotBeNull();
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            await _service.DeleteTour(_tourId);
        }


        [TestMethod]
        public async Task CreateSceneShouldCreateScene()
        {
            var newScene = new SceneDTO()
            {
                Name = nameof(CreateSceneShouldCreateScene),
            };

            var sceneId = await _service.CreateScene(_tourId, newScene);

            var tour = await _service.GetTour(_tourId);
            tour.Scenes.Should().Contain(s => s.Id == sceneId && s.Name == newScene.Name);
        }

        [TestMethod]
        public async Task DeleteSceneShouldDeleteScene()
        {
            var newScene = new SceneDTO()
            {
                Name = nameof(DeleteSceneShouldDeleteScene),
            };

            var sceneId = await _service.CreateScene(_tourId, newScene);

            var tour = await _service.GetTour(_tourId);
            tour.Scenes.Should().Contain(s => s.Id == sceneId && s.Name == newScene.Name);

            await _service.DeleteScene(_tourId, sceneId);

            var tourAfterSceneDelete = await _service.GetTour(_tourId);
            tourAfterSceneDelete.Scenes.Should().NotContain(s => s.Id == sceneId && s.Name == newScene.Name);
        }
    }
}
