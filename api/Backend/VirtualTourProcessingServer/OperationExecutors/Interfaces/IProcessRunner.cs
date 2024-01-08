using Microsoft.Extensions.Logging;
using System.Diagnostics;

namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    internal interface IProcessRunner
    {
        Process Start(string command, string arguments);
        void ReadAllLogs(Process process, ILogger logger);
    }
}
