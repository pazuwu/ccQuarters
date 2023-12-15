#if TEST

#else

using VirtualTourAPI.Client.Parameters;

namespace VirtualTourAPI.Client.IntegrationTests
{
    [TestClass]
    public class TourTests : BaseTests
    {
        [TestMethod]
        public async Task CreateTourShouldCreateTour()
        {
            CreateTourParameters parameters = new();
            var result = await _service.CreateTour(parameters);

            result.Tour.Should().NotBeNull();
            result.Tour!.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new() { TourId = result.Tour.Id! };
            var getResult = await _service.GetTourById(getTourParameters);
            getResult.Tour.Should().NotBeNull();
            getResult.Tour!.Id.Should().Be(result.Tour!.Id);

            DeleteTourParameters deleteParameters = new() { TourId = result.Tour.Id! };
            await _service.DeleteTour(deleteParameters);
        }

        [TestMethod]
        public async Task DeleteTourShouldDeleteTour()
        {
            CreateTourParameters parameters = new();
            var result = await _service.CreateTour(parameters);

            result.Tour.Should().NotBeNull();
            result.Tour!.Id.Should().NotBeNull();

            GetTourParameters getTourParameters = new() { TourId = result.Tour.Id! };
            var getResult = await _service.GetTourById(getTourParameters);
            getResult.Tour.Should().NotBeNull();
            getResult.Tour!.Id.Should().Be(result.Tour!.Id);

            DeleteTourParameters deleteParameters = new() { TourId = result.Tour.Id! };
            await _service.DeleteTour(deleteParameters);

            var getResultAfterDelete = await _service.GetTourById(getTourParameters);
            getResultAfterDelete.Tour.Should().BeNull();
        }
    }
}

#endif