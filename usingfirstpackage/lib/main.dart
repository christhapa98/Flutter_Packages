import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:riddhahttp/riddhahttp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final userRef =
    FirebaseFirestore.instance.collection('User');

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MapWidget()
        //  const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapboxMap(),
          Positioned(
            bottom: 0,
            child: SizedBox(
              height: 100,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white.withOpacity(0.2),
                child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            child: Image.network(
                          'https://static.remove.bg/remove-bg-web/b27c50a4d669fdc13528397ba4bc5bd61725e4cc/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg',
                          height: 100,
                        )),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MapboxMap extends StatelessWidget {
  const MapboxMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onTap: (position, latlng) {
          print(position.relative);
          print(latlng);
        },
        nePanBoundary: LatLng(51.5, -0.09),
        center: LatLng(51.5, -0.09),
        maxZoom: 25.0,
      ),
      layers: [
        TileLayerOptions(
          fastReplace: true,
          backgroundColor: Colors.red.withOpacity(0.1),
          urlTemplate:
              // "https://api.mapbox.com/styles/v1/christhapa9/cl165r5gu003n14phpx8z6zui/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2hyaXN0aGFwYTkiLCJhIjoiY2tzcjZ1ZXU0MGsxOTJxb2Rzc24xNG5jaCJ9.ZmL-vTc76lKw8crhEAFAcw",
              "https://api.mapbox.com/styles/v1/christhapa9/cksta28xk0q8417qulxb4qpve/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2hyaXN0aGFwYTkiLCJhIjoiY2tzcjZ1ZXU0MGsxOTJxb2Rzc24xNG5jaCJ9.ZmL-vTc76lKw8crhEAFAcw",
        ),
        PolylineLayerOptions(polylineCulling: false, polylines: [
          Polyline(
              points: [
                LatLng(51.5, -0.09),
                LatLng(52.5, -0.09),
                LatLng(52.5, -1.4),
                LatLng(52.7, -1.6),
                LatLng(50.2, -2),
                LatLng(55.5, -0.09)
              ],
              isDotted: true,
              color: Colors.red,
              strokeWidth: 3.0,
              borderColor: Colors.red,
              borderStrokeWidth: 5.0,
              gradientColors: [
                Colors.red,
                Colors.blue,
                Colors.pink,
                Colors.yellow
              ])
        ]),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(51.5, -0.09),
              builder: (ctx) => const Icon(
                Icons.room,
                color: Colors.green,
                size: 35,
              ),
            ),
            Marker(
              width: 85.0,
              height: 80.0,
              point: LatLng(55.5, -0.09),
              builder: (ctx) => GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.room,
                  color: Colors.blue.shade900,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final RiddhaHttpService _httpservice = RiddhaHttpService();

  getRates() async {
    log('loading');
    try {
      var result = await _httpservice.get(
          'https://www.muktinathbank.com.np/online/rest-api/services/get_exchange_rate');
      print(result);
    } catch (e) {
      log(e.toString());
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    getRates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
