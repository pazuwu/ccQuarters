using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Mappers
{
    public static class AreaMapper
    {
        public static AreaDTO Map(AreaDBO area)
        {
            return new()
            {
                Id = area.Id,
                Name = area.Name,   
                OperationId = area.OperationId,
            };
        }

        public static NewAreaDBO Map(NewAreaDTO area) 
        {
            return new()
            {
                Name = area.Name,
            };
        }
    }
}
