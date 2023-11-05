namespace CCQuartersAPI.CommonClasses
{
    public enum OfferType
    {
        Rent,
        Sale
    }

    public enum BuildingType
    {
        House,
        Apartment,
        Room
    }

    public enum SortingMethod
    {
        ByUpdateDateDescending = 0,
        ByPriceAscending,
        ByPriceDescending,
        ByPricePerM2Ascending,
        ByPricePerM2Descending,
    }
}
