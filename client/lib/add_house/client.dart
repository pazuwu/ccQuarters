// class SearchLocation {
//   final _client = http.Client();
//   final kGoogleApiKey = "AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY";

//   Future<void> GetPlaces(String input) async {
//     var response = await _client.get(
//         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input"
//         "&types=establishment&language=en&components=country:in&key=$kGoogleApiKey&sessiontoken=19");
//   }
// }
