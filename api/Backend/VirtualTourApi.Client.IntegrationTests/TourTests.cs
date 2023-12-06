using VirtualTourAPI.Client.Parameters;

namespace VirtualTourAPI.Client.IntegrationTests
{
    [TestClass]
    public class TourTests : BaseTests
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