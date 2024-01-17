#if TEST

#else

#nullable disable

using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using RepositoryLibrary;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.IntegrationTests
{
    [TestClass]
    public class VTServiceAreaTests : BaseVTServiceTests
    {
        private static string _tourId;
        private readonly IAreaService _areaService;

        public VTServiceAreaTests() : base()
        {
            var loogerMock = new Mock<ILogger<AreaService>>();
            var repository = new DocumentDBRepository();
            _areaService = new AreaService(repository, loogerMock.Object);
        }

        [ClassInitialize]
        public static async Task Initialize(TestContext testContext)
        {
            var tour = new NewTourDTO()
            {
                Name = "Name",
                OwnerId = "UserId"
            };

            _tourId = await _tourService.CreateTour(tour);
            _tourId.Should().NotBeNull();
        }

        [ClassCleanup]
        public static async Task Cleanup()
        {
            await _tourService.DeleteTour(_tourId);
        }

        [TestMethod]
        public async Task CreateAreaShouldCreateArea()
        {
            var area = new NewAreaDTO()
            {
                Name = nameof(CreateAreaShouldCreateArea),
            };

            var areaId = await _areaService.CreateArea(_tourId, area);

            var tour = await _tourService.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(a => a.Id == areaId && a.Name == area.Name);
        }

        [TestMethod]
        public async Task DeleteAreaShouldDeleteArea()
        {
            var area = new NewAreaDTO()
            {
                Name = nameof(DeleteAreaShouldDeleteArea),
            };

            var areaId = await _areaService.CreateArea(_tourId, area);

            var tour = await _tourService.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            await _areaService.DeleteArea(_tourId, areaId);

            var tourAfterSceneDelete = await _tourService.GetTourForEdit(_tourId);
            tourAfterSceneDelete.Areas.Should().NotContain(s => s.Id == areaId && s.Name == area.Name);
        }

        [TestMethod]
        public async Task AddPhotoToAreaShouldAddPhotoId()
        {
            var area = new NewAreaDTO()
            {
                Name = "Area name",
            };

            var areaId = await _areaService.CreateArea(_tourId, area);

            var tour = await _tourService.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            var photoId = await _areaService.AddPhotoToArea(_tourId, areaId);
            
            var tourAfterAddPhoto = await _tourService.GetTourForEdit(_tourId);
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

            var areaId = await _areaService.CreateArea(_tourId, area);

            var tour = await _tourService.GetTourForEdit(_tourId);
            tour.Areas.Should().Contain(s => s.Id == areaId && s.Name == area.Name);

            var photoId = await _areaService.AddPhotoToArea(_tourId, areaId);

            var areaAfterAddPhoto = await _areaService.GetArea(_tourId, areaId);
            areaAfterAddPhoto.Should().NotBeNull();
            areaAfterAddPhoto.Id.Should().Be(areaId);
            areaAfterAddPhoto.Name.Should().Be(area.Name);
        }
    }
}

#endif