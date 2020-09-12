import 'package:flutter/material.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  _onMapCreated(GoogleMapController controller) {
    setState(() {
      var mapController = controller;
    });}
void getcurrentlocation_() async {
  Position position = await getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
  Set<Marker> _markers = Set<Marker>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("MapHome"),
         leading: Icon(Icons.format_align_justify)
       ),
        body: Stack( children:[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(27.7172,85.32404),
              zoom:15
            ),
            onMapCreated:_onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
          )

    ]
    ),

    );

  }
}

