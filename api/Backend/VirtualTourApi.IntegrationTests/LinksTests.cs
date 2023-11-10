using VirtualTourAPI.ServiceClient.Model;
using VirtualTourAPI.ServiceClient.Parameters;

#nullable disable

namespace VirtualTourApi.IntegrationTests
{
    internal class LinksTests : BaseVTApiTests
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

            var createSceneParameters = new CreateSceneParameters() { TourId = _tour.Id };
            await _service.CreateScene(createSceneParameters);
            await _service.CreateScene(createSceneParameters);

            var getTourParameters = new GetTourParameters() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Scenes
                .Should().NotBeNull()
                .And.Subject.Should().HaveCount(2);
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            var deleteParameters = new DeleteTourParameters() { TourId = _tour.Id! };
            await _service.DeleteTour(deleteParameters);
        }

        [TestMethod]
        public async Task CreateThenDelete()
        {
            var createSceneParameters = new CreateLinkParameters() 
            { 
                TourId = _tour.Id,
                ParentId = _tour.Scenes[0].Id,
                DestinationId = _tour.Scenes[1].Id,
            };
            var result = await _service.CreateLink(createSceneParameters);

            result.Link.Should().NotBeNull();
            result.Link.Id.Should().NotBeNull();

            var getTourParameters = new GetTourParameters()
            {
                TourId = _tour.Id,
            };
            var getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Links
                .Should().NotBeNull()
                .And.Subject.Should().Contain(result.Link);
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
                .And.Subject.Should().NotContain(result.Link);
        }
    }
}
