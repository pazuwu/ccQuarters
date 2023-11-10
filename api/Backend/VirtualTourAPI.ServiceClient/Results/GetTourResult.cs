using VirtualTourAPI.ServiceClient.Model;

namespace VirtualTourAPI.ServiceClient.Results
{
    public class GetTourResult
    {
        public required TourDTO Tour { get; set; }
    }
}
