using Microsoft.Extensions.Logging;
using System.Diagnostics;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    internal class ProcessRunner : IProcessRunner
    {
        public Process Start(string command, string arguments)
        {
            var startInfo = new ProcessStartInfo(command, arguments)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
            };

            var process = new Process()
            {
                StartInfo = startInfo,
            };

            process.Start();

            return process;
        }

        public void ReadAllLogs(Process process, ILogger logger)
        {
            while (!process.StandardOutput.EndOfStream)
            {
                var line = process.StandardOutput.ReadLine();
                logger.LogCritical(line);
            }
            while (!process.StandardError.EndOfStream)
            {
                var line = process.StandardError.ReadLine();
                logger.LogCritical(line);
            }
        }
    }
}
