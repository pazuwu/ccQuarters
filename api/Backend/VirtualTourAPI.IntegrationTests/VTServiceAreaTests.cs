#if TEST

#else

#nullable disable

using FluentAssertions;
using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceAreaTests : BaseVTServiceTests
    {
        private static string _tourId;

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
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            await _service.DeleteTour(_tourId);
        }

        [TestMethod]
        public async Task CreateAreaShouldCreateArea()
        {
            var area = new NewAreaDTO()
            {
                Name = nameof(CreateAreaShouldCreateArea),
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(a => a.Id == areaId && a.Name == area.Name);
        }

        [TestMethod]
        public async Task DeleteAreaShouldDeleteArea()
        {
            var area = new NewAreaDTO()
            {
                Name = nameof(DeleteAreaShouldDeleteArea),
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            await _service.DeleteArea(_tourId, areaId);

            var tourAfterSceneDelete = await _service.GetTourForEdit(_tourId);
            tourAfterSceneDelete.Areas.Should().NotContain(s => s.Id == areaId && s.Name == area.Name);
        }

        [TestMethod]
        public async Task AddPhotoToAreaShouldAddPhotoId()
        {
            var area = new NewAreaDTO()
            {
                Name = "Area name",
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            var photoId = await _service.AddPhotoToArea(_tourId, areaId);
            
            var tourAfterAddPhoto = await _service.GetTourForEdit(_tourId);
            var areaAfterAddPhoto = tourAfterAddPhoto.Areas.Find(a => a.Id == areaId);
            areaAfterAddPhoto.Should().NotBeNull();
        }

        [TestMethod]
        public async Task GetAreaShouldReturnArea()
        {
            var area = new NewAreaDTO()
            {
                Name = "Area name",
            };

            var areaId = await _service.CreateArea(_tourId, area);

            var tour = await _service.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            var photoId = await _service.AddPhotoToArea(_tourId, areaId);

            var areaAfterAddPhoto = await _service.GetArea(_tourId, areaId);
            areaAfterAddPhoto.Should().NotBeNull();
            areaAfterAddPhoto.Id.Should().Be(areaId);
            areaAfterAddPhoto.Name.Should().Be(area.Name);
        }
    }
}

#endif