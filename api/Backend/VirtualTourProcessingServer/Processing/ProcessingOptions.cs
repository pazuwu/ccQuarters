
namespace VirtualTourProcessingServer.Processing
{
    public class ProcessingOptions
    {
        public int MaxProcessingAttempts { get; set; } = 5;
        public int MaxMultiprocessingThreads { get; set; } = 5; 
        public required string StorageDirectory { get; set; }
    }
}
