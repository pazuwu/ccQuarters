using VirtualTourAPI.Client.Model;
using VirtualTourAPI.Client.Parameters;

#nullable disable

namespace VirtualTourAPI.Client.IntegrationTests
{
    [TestClass]
    public class LinksTests : BaseTests
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

            CreateSceneParameters createSceneParameters = new() { TourId = _tour.Id };
            await _service.CreateScene(createSceneParameters);
            await _service.CreateScene(createSceneParameters);

            GetTourParameters getTourParameters = new() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Scenes
                .Should().NotBeNull()
                .And.Subject.Should().HaveCount(2);

            _tour = getTourResult.Tour;
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            DeleteTourParameters deleteParameters = new() { TourId = _tour.Id! };
            await _service.DeleteTour(deleteParameters);
        }

        [TestMethod]
        public async Task CreateLinkShouldCreateLink()
        {
            var createSceneParameters = new CreateLinkParameters()
            {
                TourId = _tour.Id,
                Text = "Link text",
                ParentId = _tour.Scenes[0].Id,
                DestinationId = _tour.Scenes[1].Id,
                Position = new GeoPointDTO(10, 20),
                NextOrientation = new GeoPointDTO(30, 40),
            };
            var result = await _service.CreateLink(createSceneParameters);

            var link = result.Link;
            link.Should().NotBeNull();
            link.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);

            getTourResult.Tour.Should().NotBeNull();

            getTourResult.Tour.Links.Should().Contain(l => SameLinkAs(l, link));

            getTourResult.Tour.Scenes
                .Should().Contain(s => s.Id == link.ParentId)
                .And.Subject.Should().Contain(s => s.Id == link.DestinationId);
        }

        [TestMethod]
        public async Task DeleteLinkShouldDeleteLink()
        {
            var createSceneParameters = new CreateLinkParameters() 
            {
                TourId = _tour.Id,
                Text = "Link text",
                ParentId = _tour.Scenes[0].Id,
                DestinationId = _tour.Scenes[1].Id,
                Position = new GeoPointDTO(10, 20),
                NextOrientation = new GeoPointDTO(30, 40),
            };
            var result = await _service.CreateLink(createSceneParameters);

            result.Link.Should().NotBeNull();
            result.Link.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new GetTourParameters() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);

            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Links
                .Should().NotBeNull()
                .And.Subject.Should().Contain(l => SameLinkAs(l, result.Link));

            getTourResult.Tour.Scenes
                .Should().Contain(s => s.Id == result.Link.ParentId)
                .And.Subject.Should().Contain(s => s.Id == result.Link.DestinationId);

            var deleteLinkParameters = new DeleteLinkParameters()
            {
                TourId = _tour.Id,
                LinkId = result.Link.Id
            };
            await _service.DeleteLink(deleteLinkParameters);

            getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Links
                .Should().NotBeNull()
                .And.Subject.Should().NotContain(l => SameLinkAs(l, result.Link));
        }

        [TestMethod]
        public async Task UpdateLinkShouldUpdateLink()
        {
            CreateLinkParameters createParameters = new()
            {
                TourId = _tour.Id,
                Text = "Link text",
                ParentId = _tour.Scenes[0].Id,
                DestinationId = _tour.Scenes[1].Id,
                Position = new GeoPointDTO(10, 20),
                NextOrientation = new GeoPointDTO(30, 40),
            };

            var createLinkResult = await _service.CreateLink(createParameters);
            var link = createLinkResult.Link;

            GetTourParameters getTourParameters = new GetTourParameters() { TourId = _tour.Id };
            var tourResult = await _service.GetTourById(getTourParameters);

            tourResult.Tour.Links.Should().Contain(l => SameLinkAs(l, link));

            UpdateLinkParameters linkUpdateParameters = new()
            {
                TourId = _tour.Id,
                LinkId = link.Id,
                Text = "Changed link text",
                DestinationId = _tour.Scenes[0].Id,
                NextOrientation = new GeoPointDTO(50, 60),
                Position = new GeoPointDTO(70, 80),
            };
            var updateResult = await _service.UpdateLink(linkUpdateParameters);

            tourResult = await _service.GetTourById(getTourParameters);

            tourResult.Tour.Links.Should().NotContain(l => SameLinkAs(l, link));

            tourResult.Tour.Links.Should().Contain(
                l => l.Id == link.Id
                && l.DestinationId == linkUpdateParameters.DestinationId
                && l.NextOrientation.Latitude == linkUpdateParameters.NextOrientation.Latitude
                && l.NextOrientation.Longitude == linkUpdateParameters.NextOrientation.Longitude
                && l.Text == linkUpdateParameters.Text
                && l.NextOrientation.Latitude == linkUpdateParameters.NextOrientation.Latitude
                && l.NextOrientation.Longitude == linkUpdateParameters.NextOrientation.Longitude);
        }

        private bool SameLinkAs(LinkDTO firstLink, LinkDTO secondLink)
        {
            return firstLink.Id == secondLink.Id
                && firstLink.DestinationId == secondLink.DestinationId
                && firstLink.NextOrientation.Latitude == secondLink.NextOrientation.Latitude
                && firstLink.NextOrientation.Longitude == secondLink.NextOrientation.Longitude
                && firstLink.Text == secondLink.Text
                && firstLink.ParentId == secondLink.ParentId
                && firstLink.NextOrientation.Latitude == secondLink.NextOrientation.Latitude
                && firstLink.NextOrientation.Longitude == secondLink.NextOrientation.Longitude;
        }
    }
}
