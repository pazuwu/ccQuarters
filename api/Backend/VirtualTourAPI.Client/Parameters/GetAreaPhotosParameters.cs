﻿
namespace VirtualTourAPI.Client.Parameters
{
    public class GetAreaPhotosParameters
    {
        public required string TourId { get; set; }
        public required string AreaId { get; set; }
    }
}
