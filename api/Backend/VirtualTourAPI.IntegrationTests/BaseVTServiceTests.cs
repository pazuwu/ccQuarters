using Microsoft.Extensions.Logging;
using Moq;
using RepositoryLibrary;
using VirtualTourAPI.Service;

namespace VirtualTourAPI.IntegrationTests
{
    public class BaseVTServiceTests
    {
        protected static readonly IVTService _service;

        static BaseVTServiceTests()
        {
            var loogerMock = new Mock<ILogger<VTService>>();
            var repository = new DocumentDBRepository();
            _service = new VTService(repository, loogerMock.Object);
        }
    }
}
