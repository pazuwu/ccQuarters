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

        public async Task<DocumentSnapshot?> GetAsync(string collectionName, string documentName)
        {
            var documentSnapshot = await firestoreDB.Collection(collectionName).Document(documentName).GetSnapshotAsync();

            if (documentSnapshot.Exists)
                return documentSnapshot;

            return null;
        }

        public async Task<string> SetAsync(string collectionName, string documentName, object values)
        {
            var doc = firestoreDB.Collection(collectionName).Document(documentName);
            await doc.SetAsync(values, SetOptions.MergeAll);
            return doc.Id;
        }
        public async Task<string> DeleteAsync(string collectionName, string documentName)
        {
            var doc = firestoreDB.Collection(collectionName).Document(documentName);
            await doc.DeleteAsync();
            return doc.Id;
        }
    }
}
