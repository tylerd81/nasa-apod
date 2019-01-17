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
  bool loading = true;

  NasaApod(this.apiUrl);

  NasaApod.fromJson(String jsonData) {
    _apodJsonParse(jsonData);
  }

  void onDate(DateTime dt) {
    String month;
    String day;

    if (dt.month < 10) {
      month = "0${dt.month}";
    } else {
      month = dt.month.toString();
    }

    if (dt.day < 10) {
      day = "0${dt.day}";
    } else {
      day = dt.day.toString();
    }

    print("${dt.year}-$month-$day");
    apiOnDate = "${dt.year}-$month-$day";
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
    loading = false;
  }
}
