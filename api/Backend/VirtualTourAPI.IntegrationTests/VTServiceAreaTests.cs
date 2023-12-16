#nullable disable

using FluentAssertions;
using VirtualTourAPI.Model;

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceAreaTests : BaseVTServiceTests
    {
        private static string _tourId;

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
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            await _service.DeleteTour(_tourId);
        }

        [TestMethod]
        public async Task CreateAreaShouldCreateArea()
        {
            var area = new AreaDTO()
            {
                Name = nameof(CreateAreaShouldCreateArea),
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTour(_tourId);
            tour.Areas.Should().Contain(a => a.Id == areaId && a.Name == area.Name);
        }

        [TestMethod]
        public async Task DeleteAreaShouldDeleteArea()
        {
            var area = new AreaDTO()
            {
                Name = nameof(DeleteAreaShouldDeleteArea),
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTour(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            await _service.DeleteArea(_tourId, areaId);

            var tourAfterSceneDelete = await _service.GetTour(_tourId);
            tourAfterSceneDelete.Areas.Should().NotContain(s => s.Id == areaId && s.Name == area.Name);
        }

        [TestMethod]
        public async Task AddPhotoToAreaShouldAddPhotoId()
        {
            var area = new AreaDTO()
            {
                Name = "Area name",
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTour(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            var photoId = Guid.NewGuid().ToString();

            await _service.AddPhotoToArea(_tourId, areaId, photoId);
            
            var tourAfterAddPhoto = await _service.GetTour(_tourId);
            var areaAfterAddPhoto = tourAfterAddPhoto.Areas.Find(a => a.Id == areaId);
            areaAfterAddPhoto.Should().NotBeNull();
            areaAfterAddPhoto.PhotoIds.Should().Contain(photoId);
        }

        [TestMethod]
        public async Task GetAreaShouldReturnArea()
        {
            var area = new AreaDTO()
            {
                Name = "Area name",
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTour(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            var photoId = Guid.NewGuid().ToString();

            await _service.AddPhotoToArea(_tourId, areaId, photoId);

            var areaAfterAddPhoto = await _service.GetArea(_tourId, areaId);
            areaAfterAddPhoto.Should().NotBeNull();
            areaAfterAddPhoto.Id.Should().Be(areaId);
            areaAfterAddPhoto.Name.Should().Be(area.Name);
            areaAfterAddPhoto.PhotoIds.Should().Contain(photoId);
        }
    }
}
