using VirtualTourAPI.Client.Model;
using VirtualTourAPI.Client.Parameters;

#nullable disable

namespace VirtualTourAPI.Client.IntegrationTests
{
    [TestClass]
    public class AreasTests : BaseTests
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
        public async Task AddAreaThenDelete()
        {
            var createSceneParameters = new CreateAreaParameters()
            {
                TourId = _tour.Id,
            };
            var result = await _service.CreateArea(createSceneParameters);

            result.Area.Should().NotBeNull();
            result.Area.Id.Should().NotBeNull();

            var getTourParameters = new GetTourParameters()
            {
                TourId = _tour.Id,
            };
            var getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Areas
                .Should().NotBeNull()
                .And.Subject.Should().Contain(a => a.Id == result.Area.Id);

            var deleteSceneParameters = new DeleteAreaParameters()
            {
                TourId = _tour.Id,
                AreaId = result.Area.Id
            };
            await _service.DeleteArea(deleteSceneParameters);

            getTourResult = await _service.GetTourById(getTourParameters);
            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Areas
                .Should().NotBeNull()
                .And.Subject.Should().NotContain(result.Area);
        }
    }
}
