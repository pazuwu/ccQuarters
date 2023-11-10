namespace VirtualTourAPI.ServiceClient
{
    public class VTClient
    {
        public IVTService Service { get; }
        
        public VTClient(HttpClient httpClient)
        {
            Service = new VTService(httpClient);
        }
    }
}