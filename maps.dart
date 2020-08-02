import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as prefix0;

class MapsPage extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<MapsPage> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex;
  double lat = 0.0;
  double long = 0.0;
  int time;
  final Map<String, Marker> _markers = {};
  // bool isloaded= false;
  var db = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:
          // isloaded ?
          GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 14.4746,
        ),
        onMapCreated: _onMapCreated,
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        backgroundColor: Colors.blueGrey,
        highlightElevation: 1,
        elevation: 15,
        child: Image.asset(
          'img/logo.png',
          scale: 1.5,
        ),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }

  @override
  void initState() {
    getvalue();
    super.initState();
  }

  getvalue() async {
    var data = db.reference().child('bot/loc').limitToLast(1);
    data.onValue.listen((Event onData) async {
      double l1 = 0;
      double l2 = 0;
      String t1;
      Map<dynamic, dynamic> a = onData.snapshot.value;
      print(a.toString());
      a.forEach((key, value) {
        l1 = value['lat'] * 1.0;
        l2 = value['long'] * 1.0;
        t1 = DateTime.fromMillisecondsSinceEpoch(value['time'])
            .toString()
            .split('.')[0];
        //  t1= value['time']*10;
      });
      BitmapDescriptor g = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(10,5)), 'img/logo.png');

      setState(() {
        lat = l1;
        long = l2;

        _markers.clear();

        var marker2 = Marker(
          markerId: MarkerId('AQUA BOT'),
         icon: BitmapDescriptor.defaultMarker,
        
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
            
            title: 'AQUA BOT',
            snippet: t1,
          ),
        );
        final marker = marker2;
        _markers['AQUABOT'] = marker;
      });
      final GoogleMapController controller = await _controller.future;
      _kGooglePlex = CameraPosition(
        target: LatLng(lat, long),
        zoom: 14.4746,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
    });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;

    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }
}
