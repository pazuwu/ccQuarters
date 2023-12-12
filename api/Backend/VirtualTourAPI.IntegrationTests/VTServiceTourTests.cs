using FluentAssertions;

#nullable disable

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceTourTests : BaseVTServiceTests
    {
        [TestMethod]
        public async Task CreateTourShouldCreateTour()
        {
            var tourId = await _service.CreateTour();
            tourId.Should().NotBeNull();

            var tour = await _service.GetTour(tourId);
            tour.Should().NotBeNull();
            tour.Id.Should().Be(tourId);

            await _service.DeleteTour(tourId);
        }

        [TestMethod]
        public async Task DeleteTourShouldDeleteTour()
        {
            var tourId = await _service.CreateTour();
            tourId.Should().NotBeNull();

            var tour = await _service.GetTour(tourId);
            tour.Should().NotBeNull();
            tour.Id.Should().Be(tourId);

            await _service.DeleteTour(tourId);

            var tourAfterDelete = await _service.GetTour(tourId);
            tourAfterDelete.Should().BeNull();
        }
    }
}
