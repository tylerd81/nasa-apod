import "dart:convert";
import "package:http/http.dart" as http;
import "key.dart";

const nasaApiUrl = "https://api.nasa.gov/planetary/apod?api_key=$apiKey";

class NasaApod {
  String date;
  String title;
  String explanation;
  String url;
  String apiUrl;
  String apiOnDate;

  NasaApod(this.apiUrl);

  NasaApod.fromJson(String jsonData) {
    _apodJsonParse(jsonData);
  }

  void onDate(String apiDate) {
    this.apiOnDate = apiDate;
  }

  Future<void> load() async {
    var res;
    if (apiOnDate != null) {
      res = await http.get("$apiUrl&date=$apiOnDate");
    } else {
      res = await http.get(apiUrl);
    }
    _apodJsonParse(res.body);
  }

  void _apodJsonParse(String jsonData) {
    var jsonObj = json.decode(jsonData);

    date = jsonObj["date"];
    title = jsonObj["title"];
    explanation = jsonObj["explanation"];
    url = jsonObj["url"];
  }
}
