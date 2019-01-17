import "package:flutter/material.dart";
import "package:nasa_apod/apod_parser.dart";
import "package:transparent_image/transparent_image.dart";
import "package:nasa_apod/loading_screen.dart";

void main() => runApp(MaterialApp(
      title: "NASA APOD",
      home: NasaApodApp(),
    ));

class NasaApodApp extends StatefulWidget {
  @override
  NasaApodAppState createState() => NasaApodAppState();
}

class NasaApodAppState extends State<NasaApodApp> {
  NasaApod nasaApod;
  bool loading = true;
  DateTime current;

  NasaApodAppState() {
    // String jsonData = """
    // {"copyright":"Clear Skies","date":"2019-01-17","explanation":"Gocka's, a family nickname for the mountain cabin, and a wooden sled from a generation past stand quietly under the stars. The single exposure image was taken on January 6 from Tanndalen Sweden to evoke a simple visual experience of the dark mountain skies. A pale band of starlight along the Milky Way sweeps through the scene. At the foot of Orion the Hunter, bright star Rigel shines just above the old kicksled's handrail. Capella, alpha star of Auriga the celestial charioteer, is the brightest star at the top of the frame. In fact, the familiar stars of the winter hexagon and the Pleiades star cluster can all be found in this beautiful skyscape from a northern winter night.","hdurl":"https://apod.nasa.gov/apod/image/1901/KicksledTWAN20190106.jpg","media_type":"image","service_version":"v1","title":"Cabin under the Stars","url":"https://apod.nasa.gov/apod/image/1901/KicksledTWAN20190106.jpg"}
    // """;
    // nasaApod = NasaApod.fromJson(jsonData);
    current = DateTime.now();
    nasaApod = NasaApod(nasaApiUrl);
    nasaApod.onDate(current);
    // nasaApod.load();
  }

  @override
  void initState() {
    nasaApod.load().then((v) => setState(() => loading = false));
    super.initState();
  }

  void forward() {
    DateTime now = DateTime.now();
    if (now.year == current.year &&
        now.day == current.day &&
        now.month == current.month) {
      print("Not going forward");
      return; // don't go into the future.
    } else {
      print("going forward");
      current = current.add(Duration(days: 1));
      nasaApod.onDate(current); //set the date
      nasaApod.load().then((v) => setState(() => loading = false));
    }
  }

  void back() {
    current = current.subtract(Duration(days: 1));
    nasaApod.onDate(current);

    nasaApod.load().then((v) => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.star),
          title: Text("NASA Astronomy Picture of the Day")),
      body: loading == true
          ? LoadingScreen()
          : Apod(apod: nasaApod, forward: forward, back: back),
    );
  }
}
// TODO: Add back and forward buttons to scroll through the images.
// TODO: make the date actually take a DateTime object

class Apod extends StatelessWidget {
  final NasaApod apod;
  final Function forward;
  final Function back;

  Apod({this.apod, this.forward, this.back});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Icon(
                    Icons.arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: back,
                  color: Colors.blue,
                ),
                RaisedButton(
                  child: Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                  onPressed: forward,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          ApodTitle(title: apod.title),
          ApodDate(date: apod.date),
          ApodImage(
            imageUrl: apod.url,
          ),
          ApodExplanation(explanation: apod.explanation),
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
        child: FadeInImage.memoryNetwork(
            image: imageUrl,
            placeholder: kTransparentImage), //Image.network(imageUrl),
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
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              explanation,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
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
