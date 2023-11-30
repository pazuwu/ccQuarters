using System.Text;

namespace CCQuartersAPI.CommonClasses
{
    public class HousesFilter
    {
        public double? MinPrice { get; set; }
        public double? MaxPrice { get; set; }
        public double? MinPricePerM2 { get; set; }
        public double? MaxPricePerM2 { get; set; }
        public double? MaxArea { get; set; }
        public double? MinArea { get; set; }
        public int? MaxRoomCount { get; set; }
        public int? MinRoomCount { get; set; }
        public int[]? Floors { get; set; }
        public int? MinFloor { get; set; }
        public int? MaxFloor { get; set; }
        public OfferType[]? OfferTypes { get; set; }
        public BuildingType[]? BuildingTypes { get; set; }
        public CityFilter[]? Cities { get; set; }
        public string[]? Districts { get; set; }

        public override string ToString()
        {
            var sb = new StringBuilder("1=1");

            if (MinPrice is not null)
                sb.Append($@" AND Price >= {MinPrice}");
            if (MaxPrice is not null)
                sb.Append($@" AND Price <= {MaxPrice}");
            if(MinPricePerM2 is not null)
                sb.Append($@" AND Price / Area >= {MaxPricePerM2}");
            if(MaxPricePerM2 is not null)
                sb.Append($@" AND Price / Area <= {MaxPricePerM2}");
            if (MaxArea is not null)
                sb.Append($@" AND Area <= {MaxArea}");
            if (MinArea is not null)
                sb.Append($@" AND Area >= {MinArea}");
            if (MaxRoomCount is not null)
                sb.Append($@" AND RoomCount <= {MaxRoomCount}");
            if (MinRoomCount is not null)
                sb.Append($@" AND RoomCount >= {MinRoomCount}");
            if (Floors is not null && Floors.Any())
            {
                sb.Append($@" AND Floor IN ({Floors.First()}");
                foreach(int floor in Floors.Skip(1))
                    sb.Append($@",{floor}");
                sb.Append(')');
            }
            if (MinFloor is not null)
                sb.Append($@" AND Floor >= {MinFloor}");
            if (MaxFloor is not null)
                sb.Append($@" AND Floor <= {MaxFloor}");
            if (OfferTypes is not null && OfferTypes.Any())
            {
                sb.Append($@" AND OfferType IN ({(int)OfferTypes.First()}");
                foreach (OfferType offerType in OfferTypes.Skip(1))
                    sb.Append($@",{(int)offerType}");
                sb.Append(')');
            }
            if (BuildingTypes is not null && BuildingTypes.Any())
            {
                sb.Append($@" AND BuildingType IN ({(int)BuildingTypes.First()}");
                foreach(BuildingType buildingType in BuildingTypes.Skip(1))
                    sb.Append($@",{(int)buildingType}");
                sb.Append(')');
            }
            if (Cities is not null && Cities.Any())
            {
                sb.Append($@" AND ((City = '{Cities.First().City}' AND Voivodeship = '{Cities.First().Voivodeship}')");
                foreach((string voivodeship, string city) in Cities.Skip(1))
                    sb.Append($@"OR (City = '{city}' AND Voivodeship = '{voivodeship}')");
                sb.Append(')');
            }
            if (Districts is not null && Districts.Any())
            {
                sb.Append($@" AND District IN ('{Districts.First()}'");
                foreach(string district in Districts.Skip(1))
                    sb.Append($@",'{district}'");
                sb.Append(')');
            }

            return sb.ToString();
        }
    }

    public class CityFilter
    {
        public string Voivodeship { get; set; }
        public string City { get; set; }

        public void Deconstruct(out string voivodeship, out string city)
        {
            voivodeship = Voivodeship;
            city = City;
        }
    }
}
