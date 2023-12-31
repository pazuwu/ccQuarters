﻿using Google.Cloud.Firestore;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.Processing
{
    internal class OperationPriority : IComparable<OperationPriority>
    {
        public Timestamp LastModified { get; }
        public OperationStage Status { get; }

        public OperationPriority(Timestamp lastModified, OperationStage status)
        {
            LastModified = lastModified;
            Status = status;
        }

        public int CompareTo(OperationPriority? other)
        {
            var statusComparison = Status.CompareTo(other?.Status);

            if (statusComparison == 0)
                return LastModified.CompareTo(other?.LastModified);

            return statusComparison;
        }
    }
}
