import "package:flutter/material.dart";
import "package:nasa_apod/apod_parser.dart";

void main() => runApp(NasaApodApp());

class NasaApodApp extends StatefulWidget {
  @override
  NasaApodAppState createState() => NasaApodAppState();
}

class NasaApodAppState extends State<NasaApodApp> {
  NasaApod nasaApod;

  NasaApodAppState() {
    // String jsonData = """
    // {"copyright":"Clear Skies","date":"2019-01-17","explanation":"Gocka's, a family nickname for the mountain cabin, and a wooden sled from a generation past stand quietly under the stars. The single exposure image was taken on January 6 from Tanndalen Sweden to evoke a simple visual experience of the dark mountain skies. A pale band of starlight along the Milky Way sweeps through the scene. At the foot of Orion the Hunter, bright star Rigel shines just above the old kicksled's handrail. Capella, alpha star of Auriga the celestial charioteer, is the brightest star at the top of the frame. In fact, the familiar stars of the winter hexagon and the Pleiades star cluster can all be found in this beautiful skyscape from a northern winter night.","hdurl":"https://apod.nasa.gov/apod/image/1901/KicksledTWAN20190106.jpg","media_type":"image","service_version":"v1","title":"Cabin under the Stars","url":"https://apod.nasa.gov/apod/image/1901/KicksledTWAN20190106.jpg"}
    // """;
    // nasaApod = NasaApod.fromJson(jsonData);
    nasaApod = NasaApod(nasaApiUrl);
    nasaApod.onDate("2019-01-16");
    // nasaApod.load();
  }

  @override
  void initState() {
    nasaApod.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nasa APOD",
      home: Apod(apod: nasaApod),
    );
  }
}
// TODO: Add back and forward buttons to scroll through the images.
// TODO: make the date actually take a DateTime object

class Apod extends StatelessWidget {
  final NasaApod apod;

  Apod({this.apod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.star),
        title: Text("NASA Astronomy Picture of the Day"),
      ),
      body: ListView(
        children: <Widget>[
          ApodTitle(title: apod.title),
          ApodImage(
            imageUrl: apod.url,
          ),
          ApodExplanation(explanation: apod.explanation),
          ApodDate(date: apod.date),
        ],
      ),
    );
  }
}

class ApodTitle extends StatelessWidget {
  final String title;

  ApodTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ApodImage extends StatelessWidget {
  final String imageUrl;

  ApodImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(imageUrl),
      ),
    );
  }
}

class ApodExplanation extends StatelessWidget {
  final String explanation;

  ApodExplanation({this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          explanation,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class ApodDate extends StatelessWidget {
  final String date;
  ApodDate({this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            date,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
