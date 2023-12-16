using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.IntegrationTests.Mocks;
using CCQuartersAPI.Services;
using CloudStorageLibrary;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests
{
    public static class AssertExtensions
    {
        public static void AreEqual<T>(IEnumerable<T>? expected, IEnumerable<T>? actual)
            where T : IEquatable<T>
        {
            if((expected is null || !expected.Any()) && (actual is null || !actual.Any())) return;
            Assert.IsNotNull(expected);
            Assert.IsNotNull(actual);
            Assert.IsTrue(expected.All(expectedValue => actual.Any(actualValue => expectedValue.Equals(actualValue))));
            Assert.IsTrue(actual.All(actualValue => expected.Any(expectedValue => actualValue.Equals(expectedValue))));
        }
    }
}