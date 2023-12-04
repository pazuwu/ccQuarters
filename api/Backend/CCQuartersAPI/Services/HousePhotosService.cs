using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using RepositoryLibrary;

namespace CCQuartersAPI.Services
{
    public class HousePhotosService : IHousePhotosService
    {
        private readonly IRelationalDBRepository _rdbRepository;
        private readonly IDocumentDBRepository _documentRepository;
        private readonly IStorage _storage;

        private readonly string AdditionalInfoCollection = "additionalInfos";
        private readonly string DescriptionCollection = "descriptions";
        private readonly string HousePhotosCollection = "housePhotos";

        public HousePhotosService(IRelationalDBRepository rdbRepository, IDocumentDBRepository documentRepository, IStorage storage)
        {
            _rdbRepository = rdbRepository;
            _documentRepository = documentRepository;
            _storage = storage;
        }

        public async Task<IEnumerable<PhotoDTO>> GetPhotosForHouse(Guid houseId)
        {
            var photosQuery = @$"SELECT PhotoId AS Filename, [Order] FROM HousePhotos WHERE HouseId = @houseId ORDER BY [Order]";

            var photos = await _rdbRepository.QueryAsync<PhotoDTO>(photosQuery, new { houseId });

            foreach (var photo in photos)
                photo.Url = await _storage.GetDownloadUrl("housePhotos", photo.Filename);

            return photos;
        }

        public async Task<IEnumerable<HousePhotoQueried>> GetPhotosInfoByNames(IEnumerable<string> filenames)
        {
            var getQuery = @$"SELECT HouseId, UserId, PhotoId AS Filename, [Order]
                        FROM Houses h
                        LEFT JOIN HousePhotos p ON h.Id = p.HouseId
                        WHERE PhotoId IN @filenames";

            return await _rdbRepository.QueryAsync<HousePhotoQueried>(getQuery, new { filenames });
        }

        public async Task DeletePhotosByNames(IEnumerable<string> filenames)
        {
            var deleteQuery = $@"DELETE FROM HousePhotos WHERE PhotoId IN @filenames";

            await _rdbRepository.ExecuteAsync(deleteQuery, new { filenames });

            foreach (string filename in filenames)
                await _storage.DeleteFileAsync("housePhotos", filename);
        }

        public async Task AddHousePhoto(Guid houseId, Stream fileStream)
        {
            var selectQuery = $@"SELECT [Order] FROM HousePhotos WHERE HouseId = @houseId ORDER BY [Order] DESC";

            int count = await _rdbRepository.QueryFirstOrDefaultAsync<int?>(selectQuery, new { houseId }) ?? 0;

            int order = count + 1;

            string filename = $@"{houseId}_{order}";

            var insertQuery = $@"INSERT INTO HousePhotos VALUES (@houseId, @filename, @order)";

            await _rdbRepository.ExecuteAsync(insertQuery, new { houseId, filename, order });

            await _storage.UploadFileAsync(HousePhotosCollection, fileStream, filename);
        }
    }
}
