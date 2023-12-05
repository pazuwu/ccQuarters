namespace CCQuartersAPI.CommonClasses
{
    public class BaseBulkResponse<T>
    {
        public T[]? Data { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
    }
}
