#if TEST

#else

using Microsoft.Extensions.Logging;
using Moq;
using RepositoryLibrary;
using VirtualTourAPI.Services;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.IntegrationTests
{
    public class BaseVTServiceTests
    {
        protected static readonly ITourService _tourService;

        static BaseVTServiceTests()
        {
            var loogerMock = new Mock<ILogger<TourService>>();
            var repository = new DocumentDBRepository();
            _tourService = new TourService(repository, loogerMock.Object);
        }
    }
}

#endif