﻿using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class GetHouseResponse
    {
        public required DetailedHouseDTO House { get; set; }
        public PhotoDTO[]? Photos { get; set; }
    }

    public class DetailedHouseQueried
    {
        public required string Title { get; set; }
        public decimal Price { get; set; }
        public int RoomCount { get; set; }
        public decimal Area { get; set; }
        public int? Floor { get; set; }
        public required string DescriptionId { get; set; }
        public required string AdditionalInfoId { get; set; }
        public string? VirtualTourId { get; set; }
        public required string UserId { get; set; }
        public required string City { get; set; }
        public required string Voivodeship { get; set; }
        public required string ZipCode { get; set; }
        public string? District { get; set; }
        public string? StreetName { get; set; }
        public string? StreetNumber { get; set; }
        public string? FlatNumber { get; set; }
        public decimal? GeoX { get; set; }
        public decimal? GeoY { get; set; }
        public OfferType OfferType { get; set; }
        public BuildingType BuildingType { get; set; }
        public bool IsLiked { get; set; }
    }

    public class DetailedHouseDTO
    {
        public required string UserId { get; set; }
        public required string Title { get; set; }
        public decimal Price { get; set; }
        public int RoomCount { get; set; }
        public decimal Area { get; set; }
        public int? Floor { get; set; }
        public required string DescriptionId { get; set; }
        public string? Description { get; set; }
        public required string AdditionalInfoId { get; set; }
        public Dictionary<string, object>? AdditionalInfo { get; set; }
        public required string City { get; set; }
        public required string Voivodeship { get; set; }
        public required string ZipCode { get; set; }
        public string? District { get; set; }
        public string? StreetName { get; set; }
        public string? StreetNumber { get; set; }
        public string? FlatNumber { get; set; }
        public decimal? GeoX { get; set; }
        public decimal? GeoY { get; set; }
        public OfferType OfferType { get; set; }
        public BuildingType BuildingType { get; set; }
        public bool IsLiked { get; set; }
        public string? UserName { get; set; }
        public string? UserSurname { get; set; }
        public string? UserCompany {  get; set; }
        public string? UserEmail { get; set; }
        public string? UserPhoneNumber { get; set; }
        public string? UserPhotoUrl { get; set; }
        public string? VirtualTourId { get; set; }
    }

    public class PhotoDTO
    {
        public required string Filename { get; set; }
        public required string Url { get; set; }
        public int Order { get; set; }
    }
}
