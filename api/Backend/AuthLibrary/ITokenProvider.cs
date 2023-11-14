namespace AuthLibrary
{
    public interface ITokenProvider
    {
        public Task<string> GetUserToken();
        public Task<string> GetServerToken();
    }
}
