#if TEST

#else

using FluentAssertions;
using VirtualTourAPI.DTOModel;

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
            var tour = new NewTourDTO()
            {
                Name = "Name",
                OwnerId = "UserId"
            };

            _tourId = await _service.CreateTour(tour);
            _tourId.Should().NotBeNull();

            var firstScene = new NewSceneDTO() { Name = "First scene" };
            _firstSceneId = await _service.CreateScene(_tourId, firstScene);

            var secondScene = new NewSceneDTO() { Name = "Second scene" };
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
            var newLink = new NewLinkDTO()
            {
                Text = "New link",
                ParentId = _firstSceneId,
                DestinationId = _secondSceneId,
                Position = new GeoPointDTO(10, 20),
                NextOrientation = new GeoPointDTO(30, 40),
            };

            var linkId = await _service.CreateLink(_tourId, newLink);

            var link = new LinkDTO()
            {
                Id = linkId,
                Text = newLink.Text,
                ParentId = newLink.ParentId,
                DestinationId = newLink.DestinationId,
                Position = newLink.Position,
                NextOrientation = newLink.NextOrientation,
            };

            var tour = await _service.GetTourForEdit(_tourId);

            tour.Links.Should().Contain(l => SameLinkAs(l, link));
        }

        [TestMethod]
        public async Task DeleteLinkShouldDeleteLink()
        {
            var newLink = new NewLinkDTO()
            {
                Text = "New link",
                ParentId = _firstSceneId,
                DestinationId = _secondSceneId,
                Position = new GeoPointDTO(10, 20),
                NextOrientation = new GeoPointDTO(30, 40),
            };

            var linkId = await _service.CreateLink(_tourId, newLink);

            var link = new LinkDTO()
            {
                Id = linkId,
                Text = newLink.Text,
                ParentId = newLink.ParentId,
                DestinationId = newLink.DestinationId,
                Position = newLink.Position,
                NextOrientation = newLink.NextOrientation,
            };

            var tour = await _service.GetTourForEdit(_tourId);

            tour.Links.Should().Contain(l => l.Id == linkId);

            await _service.DeleteLink(_tourId, linkId);
            var tourAfterLinkDelete = await _service.GetTourForEdit(_tourId);
            tourAfterLinkDelete.Links.Should().NotContain(l => SameLinkAs(l, link));
        }

        [TestMethod]
        public async Task UpdateLinkShouldUpdateLink()
        {
            var newLink = new NewLinkDTO()
            {
                Text = "New link",
                ParentId = _firstSceneId,
                DestinationId = _secondSceneId,
                Position = new GeoPointDTO(10, 20),
                NextOrientation = new GeoPointDTO(30, 40),
            };

            var linkId = await _service.CreateLink(_tourId, newLink);

            var link = new LinkDTO()
            {
                Id = linkId,
                Text = newLink.Text,
                ParentId = newLink.ParentId,
                DestinationId = newLink.DestinationId,
                Position = newLink.Position,
                NextOrientation = newLink.NextOrientation,
            };

            var tour = await _service.GetTourForEdit(_tourId);

            tour.Links.Should().Contain(l => SameLinkAs(l, link));

            var linkAfterModification = new LinkDTO()
            {
                Id = linkId,
                Text = "Changed newLink text",
                ParentId = _secondSceneId,
                DestinationId = _firstSceneId,
                NextOrientation = new GeoPointDTO(50, 60),
                Position = new GeoPointDTO(70, 80),
            };

            await _service.UpdateLink(_tourId, linkAfterModification);
            var tourAfterLinkUpdate = await _service.GetTourForEdit(_tourId);

            tourAfterLinkUpdate.Links.Should().NotContain(l => SameLinkAs(l, link));
            tourAfterLinkUpdate.Links.Should().Contain(l => SameLinkAs(l, linkAfterModification));
        }


        private bool SameLinkAs(LinkDTO firstLink, LinkDTO secondLink)
        {
            return firstLink.Id == secondLink.Id
                && firstLink.DestinationId == secondLink.DestinationId
                && firstLink.NextOrientation?.Latitude == secondLink.NextOrientation?.Latitude
                && firstLink.NextOrientation?.Longitude == secondLink.NextOrientation?.Longitude
                && firstLink.Text == secondLink.Text
                && firstLink.ParentId == secondLink.ParentId
                && firstLink.Position.Latitude == secondLink.Position.Latitude
                && firstLink.Position.Longitude == secondLink.Position.Longitude;
        }
    }
}

#endif