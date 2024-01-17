#if TEST

#else

#nullable disable

using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using RepositoryLibrary;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services.Interfaces;
using VirtualTourAPI.Services;

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceSceneTests : BaseVTServiceTests
    {
        private static string _tourId;

        private readonly ISceneService _sceneService;

        public VTServiceSceneTests() : base()
        {
            var loogerMock = new Mock<ILogger<SceneService>>();
            var repository = new DocumentDBRepository();
            _sceneService = new SceneService(repository, loogerMock.Object);
        }

        [ClassInitialize]
        public static async Task Initialize(TestContext testContext)
        {
            var tour = new NewTourDTO()
            {
                Name = "Name",
                OwnerId = "UserId"
            };

            _tourId = await _tourService.CreateTour(tour);
            _tourId.Should().NotBeNull();
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            await _tourService.DeleteTour(_tourId);
        }


        [TestMethod]
        public async Task CreateSceneShouldCreateScene()
        {
            var newScene = new NewSceneDTO()
            {
                Name = nameof(CreateSceneShouldCreateScene),
            };

            var sceneId = await _sceneService.CreateScene(_tourId, newScene);

            var tour = await _tourService.GetTourForEdit(_tourId);
            tour.Scenes.Should().Contain(s => s.Id == sceneId && s.Name == newScene.Name);
        }

        [TestMethod]
        public async Task DeleteSceneShouldDeleteScene()
        {
            var newScene = new NewSceneDTO()
            {
                Name = nameof(DeleteSceneShouldDeleteScene),
            };

            var sceneId = await _sceneService.CreateScene(_tourId, newScene);

            var tour = await _tourService.GetTourForEdit(_tourId);
            tour.Scenes.Should().Contain(s => s.Id == sceneId && s.Name == newScene.Name);

            await _sceneService.DeleteScene(_tourId, sceneId);

            var tourAfterSceneDelete = await _tourService.GetTourForEdit(_tourId);
            tourAfterSceneDelete.Scenes.Should().NotContain(s => s.Id == sceneId && s.Name == newScene.Name);
        }
    }
}

#endif