using Google.Cloud.Firestore;

namespace RepositoryLibrary
{
    public class DocumentDBRepository : IDocumentDBRepository
    {
        private readonly string _databaseName = "ccquartersmini";
        private readonly FirestoreDb firestoreDB;

        public DocumentDBRepository()
        {
            firestoreDB = FirestoreDb.Create(_databaseName);
        }

        public async Task<DocumentSnapshot?> GetAsync(string documentPath)
        {
            var documentSnapshot = await firestoreDB.Document(documentPath).GetSnapshotAsync();

            if (documentSnapshot.Exists)
                return documentSnapshot;

            return null;
        }

        public async Task<IEnumerable<DocumentSnapshot>?> GetByFieldAsync(string collectionPath, string field, object value)
        {
            var documentSnapshot = await firestoreDB.Collection(collectionPath).WhereEqualTo(field, value).GetSnapshotAsync();

            return documentSnapshot;
        }

        public async Task<IEnumerable<DocumentSnapshot>?> GetCollectionAsync(string collectionPath)
        {
            var documentSnapshot = await firestoreDB.Collection(collectionPath).GetSnapshotAsync();

            return documentSnapshot;
        }

        public async Task<string> SetAsync(string documentPath, object values)
        {
            var doc = firestoreDB.Document(documentPath);
            await doc.SetAsync(values, SetOptions.MergeAll);
            return doc.Id;
        }
        public async Task<string> DeleteAsync(string documentPath)
        {
            var doc = firestoreDB.Document(documentPath);
            await doc.DeleteAsync();
            return doc.Id;
        }

        public async Task<string> AddAsync(string collectionPath, object values)
        {
            var doc = await firestoreDB.Collection(collectionPath).AddAsync(values);
            return doc.Id;
        }

        public async Task UpdateAsync(string documentPath, string fieldName, object value)
        {
            await firestoreDB.Document(documentPath).UpdateAsync(fieldName, value);
        }

        public async Task<long?> GetCountByFieldAsync(string collectionPath, string field, object value)
        {
            return (await firestoreDB.Collection(collectionPath).WhereEqualTo(field, value).Count().GetSnapshotAsync()).Count;
        }
    }
}
