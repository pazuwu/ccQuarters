using System.Text;

namespace CCQuartersAPI.CommonClasses
{
    public class GetHousesBody
    {
        public SortingMethod? SortMethod { get; set; }
        public HousesFilter? Filter { get; set; }

        public override string ToString()
        {
            StringBuilder sb = new();
            if (Filter is not null)
                sb.Append(Filter);
            else
                sb.Append("1=1");

            sb.Append("\nORDER BY ");

            switch (SortMethod)
            {
                case SortingMethod.ByPriceAscending:
                    sb.Append("d.Price");
                    break;
                case SortingMethod.ByPriceDescending:
                    sb.Append("d.Price DESC");
                    break;
                case SortingMethod.ByPricePerM2Ascending:
                    sb.Append("d.Price / d.Area");
                    break;
                case SortingMethod.ByPricePerM2Descending:
                    sb.Append("d.Price / d.Area DESC");
                    break;
                case SortingMethod.ByUpdateDateDescending:
                case null:
                default:
                    sb.Append("h.UpdateDate DESC");
                    break;
            }

            return sb.ToString();
        }
    }
}
