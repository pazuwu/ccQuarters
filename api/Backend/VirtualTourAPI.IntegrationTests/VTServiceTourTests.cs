#if TEST

#else

using FluentAssertions;
using VirtualTourAPI.DTOModel;

#nullable disable

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceTourTests : BaseVTServiceTests
    {
        [TestMethod]
        public async Task CreateTourShouldCreateTour()
        {
            var tour = new NewTourDTO()
            {
                Name = "Name",
                OwnerId = "UserId"
            };

            var tourId = await _service.CreateTour(tour);
            tourId.Should().NotBeNull();

            var createdTour = await _service.GetTour(tourId);
            createdTour.Should().NotBeNull();
            createdTour.Id.Should().Be(tourId);

            await _service.DeleteTour(tourId);
        }

        [TestMethod]
        public async Task DeleteTourShouldDeleteTour()
        {
            var tour = new NewTourDTO()
            {
                Name = "Name",
                OwnerId = "UserId"
            };

            var tourId = await _service.CreateTour(tour);
            tourId.Should().NotBeNull();

            var createdTour = await _service.GetTour(tourId);
            createdTour.Should().NotBeNull();
            createdTour.Id.Should().Be(tourId);

            await _service.DeleteTour(tourId);

            var tourAfterDelete = await _service.GetTour(tourId);
            tourAfterDelete.Should().BeNull();
        }

        [TestMethod]
        public async Task GetUserToursShouldReturnOnlyUsersTours()
        {
            var firstTour = new NewTourDTO()
            {
                Name = "Name",
                OwnerId = "First User"
            };

            var secondTour = new NewTourDTO()
            {
                Name = "Name",
                OwnerId = "Second User"
            };

            var firstTourId = await _service.CreateTour(firstTour);
            firstTourId.Should().NotBeNull();

            var secondTourId = await _service.CreateTour(secondTour);
            secondTourId.Should().NotBeNull();

            var firstUserTours = await _service.GetAllUserTourInfos("First User");
            firstUserTours.Should().NotBeNull();
            firstUserTours.Should().Contain(i => i.Id == firstTourId);
            firstUserTours.Should().NotContain(i => i.Id == secondTourId);

            var secondUserTours = await _service.GetAllUserTourInfos("Second User");
            secondUserTours.Should().NotBeNull();
            secondUserTours.Should().Contain(i => i.Id == secondTourId);
            secondUserTours.Should().NotContain(i => i.Id == firstTourId);

            await _service.DeleteTour(firstTourId);
            await _service.DeleteTour(secondTourId);
        }
    }
}

#endif