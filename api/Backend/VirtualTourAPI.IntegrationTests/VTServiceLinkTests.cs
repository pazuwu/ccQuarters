using FluentAssertions;
using Google.Cloud.Firestore;
using VirtualTourAPI.Model;

#nullable disable

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceLinkTests : BaseVTServiceTests
    {
        private static string _tourId;
        private static string _firstSceneId;
        private static string _secondSceneId;

        [ClassInitialize]
        public static async Task Initialize(TestContext testContext)
        {
            _tourId = await _service.CreateTour();
            _tourId.Should().NotBeNull();

            var firstScene = new SceneDTO() { Name = "First scene" };
            _firstSceneId = await _service.CreateScene(_tourId, firstScene);

            var secondScene = new SceneDTO() { Name = "Second scene" };
            _secondSceneId = await _service.CreateScene(_tourId, secondScene);
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            await _service.DeleteTour(_tourId);
        }

        [TestMethod]
        public async Task CreateLinkShouldCreateLink()
        {
            var link = new LinkDTO()
            {
                ParentId = _firstSceneId,
                DestinationId = _secondSceneId,
                Position = new GeoPoint(10, 20),
                NextOrientation = new GeoPoint(30, 40),
            };

            var linkId = await _service.CreateLink(_tourId, link);
            link.Id = linkId;

            var tour = await _service.GetTour(_tourId);

            tour.Links.Should().Contain(
                l => l.Id == linkId 
                && l.DestinationId == link.DestinationId 
                && l.NextOrientation == link.NextOrientation
                && l.Text == link.Text
                && l.ParentId == link.ParentId
                && l.NextOrientation == link.NextOrientation);
        }

        [TestMethod]
        public async Task DeleteLinkShouldDeleteLink()
        {
            var link = new LinkDTO()
            {
                ParentId = _firstSceneId,
                DestinationId = _secondSceneId,
                Position = new GeoPoint(10, 20),
                NextOrientation = new GeoPoint(30, 40),
            };

            var linkId = await _service.CreateLink(_tourId, link);
            link.Id = linkId;

            var tour = await _service.GetTour(_tourId);

            tour.Links.Should().Contain(l => l.Id == linkId);

            await _service.DeleteLink(_tourId, linkId);
            var tourAfterLinkDelete = await _service.GetTour(_tourId);
            tourAfterLinkDelete.Links.Should().NotContain(l => l.Id == linkId);
        }

        [TestMethod]
        public async Task UpdateLinkShouldUpdateLink()
        {
            var link = new LinkDTO()
            {
                Text = "Link text",
                ParentId = _firstSceneId,
                DestinationId = _secondSceneId,
                Position = new GeoPoint(10, 20),
                NextOrientation = new GeoPoint(30, 40),
            };

            var linkId = await _service.CreateLink(_tourId, link);
            link.Id = linkId;

            var tour = await _service.GetTour(_tourId);
            
            tour.Links.Should().Contain(
                l => l.Id == linkId
                && l.DestinationId == link.DestinationId
                && l.NextOrientation == link.NextOrientation
                && l.Text == link.Text
                && l.ParentId == link.ParentId
                && l.NextOrientation == link.NextOrientation);

            var linkAfterModification = new LinkDTO()
            {
                Id = linkId,
                Text = "Changed link text",
                ParentId = _secondSceneId,
                DestinationId = _firstSceneId,
                NextOrientation = new GeoPoint(50, 60),
                Position = new GeoPoint(70, 80),
            };

            await _service.UpdateLink(_tourId, linkAfterModification);
            var tourAfterLinkUpdate = await _service.GetTour(_tourId);

            tourAfterLinkUpdate.Links.Should().NotContain(
                l => l.Id == linkId
                && l.DestinationId == link.DestinationId
                && l.NextOrientation == link.NextOrientation
                && l.Text == link.Text
                && l.ParentId == link.ParentId
                && l.NextOrientation == link.NextOrientation);

            tourAfterLinkUpdate.Links.Should().Contain(
                l => l.Id == linkId
                && l.DestinationId == linkAfterModification.DestinationId
                && l.NextOrientation == linkAfterModification.NextOrientation
                && l.Text == linkAfterModification.Text
                && l.ParentId == linkAfterModification.ParentId
                && l.NextOrientation == linkAfterModification.NextOrientation);
        }
    }
}
