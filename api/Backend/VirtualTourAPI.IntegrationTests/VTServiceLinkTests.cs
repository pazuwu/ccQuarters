#if TEST

#else

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
            var tour = new TourDTO()
            {
                Name = "Name",
                OwnerId = "UserId"
            };

            _tourId = await _service.CreateTour(tour);
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

            tour.Links.Should().Contain(l => SameLinkAs(l, link));
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
            tourAfterLinkDelete.Links.Should().NotContain(l => SameLinkAs(l, link));
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
            
            tour.Links.Should().Contain(l => SameLinkAs(l, link));

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

            tourAfterLinkUpdate.Links.Should().NotContain(l => SameLinkAs(l, link));
            tourAfterLinkUpdate.Links.Should().Contain(l => SameLinkAs(l, linkAfterModification));
        }


        private bool SameLinkAs(LinkDTO firstLink, LinkDTO secondLink)
        {
            return firstLink.Id == secondLink.Id
                && firstLink.DestinationId == secondLink.DestinationId
                && firstLink.NextOrientation == secondLink.NextOrientation
                && firstLink.Text == secondLink.Text
                && firstLink.ParentId == secondLink.ParentId
                && firstLink.NextOrientation == secondLink.NextOrientation;
        }
    }
}

#endif