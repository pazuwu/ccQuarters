using VirtualTourAPI.ServiceClient.Parameters;

namespace VirtualTourApi.IntegrationTests
{
    [TestClass]
    public class TourTests : BaseVTApiTests
    {
        [TestMethod]
        public async Task CreateTourThenDelete()
        {
            var parameters = new CreateTourParameters();
            var result = await _service.CreateTour(parameters);

            result.Tour.Should().NotBeNull();
            result.Tour!.Id.Should().NotBeNull();

            var deleteParameters = new DeleteTourParameters()
            {
                TourId = result.Tour.Id!
            };
            await _service.DeleteTour(deleteParameters);
        }
    }
}