﻿
namespace VirtualTourProcessingServer.Processing
{
    public class ProcessingOptions
    {
        public int MaxProcessingAttempts { get; set; } = 5;
        public int MaxPostprocessingThreads { get; set; } = 5; 
    }
}