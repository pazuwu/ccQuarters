using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Services.Interfaces
{
    public interface ILinkService
    {
        Task<string> CreateLink(string tourId, NewLinkDTO link);
        Task UpdateLink(string tourId, LinkDTO link);
        Task DeleteLink(string tourId, string linkId);
    }
}
