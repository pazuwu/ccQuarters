#if TEST

#else

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
        public async Task CreateAreaShouldCreateArea()
        {
            CreateAreaParameters createSceneParameters = new() { TourId = _tour.Id };
            var result = await _service.CreateArea(createSceneParameters);

            result.Area.Should().NotBeNull();
            result.Area.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);

            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Areas
                .Should().NotBeNull()
                .And.Subject.Should().Contain(a => a.Id == result.Area.Id);
        }

        [TestMethod]
        public async Task DeleteAreaShouldDeleteArea()
        {
            CreateAreaParameters createSceneParameters = new() { TourId = _tour.Id };
            var result = await _service.CreateArea(createSceneParameters);

            result.Area.Should().NotBeNull();
            result.Area.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new() { TourId = _tour.Id };
            var getTourResult = await _service.GetTourById(getTourParameters);

            getTourResult.Tour.Should().NotBeNull();
            getTourResult.Tour.Areas
                .Should().NotBeNull()
                .And.Subject.Should().Contain(a => a.Id == result.Area.Id);

            DeleteAreaParameters deleteSceneParameters = new()
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

#endif