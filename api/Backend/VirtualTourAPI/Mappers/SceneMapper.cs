using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Mappers
{
    public static class SceneMapper
    {
        public static SceneDTO Map(this SceneDBO scene)
        {
            return new()
            {
                Id = scene.Id,
                Name = scene.Name,
                ParentId = scene.ParentId,
            };
        }

        public static NewSceneDBO Map(this NewSceneDTO scene)
        {
            return new()
            {
                Name = scene.Name,
                ParentId = scene.ParentId,
            };
        }
    }
}
