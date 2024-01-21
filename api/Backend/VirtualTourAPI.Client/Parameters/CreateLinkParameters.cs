﻿using VirtualTourAPI.Client.Model;

namespace VirtualTourAPI.Client.Parameters
{
    public class CreateLinkParameters
    {
        public required string TourId { get; set; }
        public string? ParentId { get; set; }
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public required GeoPointDTO Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
