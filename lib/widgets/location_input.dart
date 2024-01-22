import 'package:favplaces/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/place.dart';
import '../screens/map.dart';

class LocationInput extends StatefulWidget {
  LocationInput({super.key, required this.onSelectLocaion});
  void Function(PlaceLocation location) onSelectLocaion;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  void _SavePlace(double lat, double lon) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=");
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lon, address: address!);
      _isGettingLocation = false;
    });
    widget.onSelectLocaion(_pickedLocation!);
  }

  String get locationImage {
    final lat = _pickedLocation!.latitude;
    final lon = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lon=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:X%7C$lat,$lon&key=';
  }

  void _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;
    _SavePlace(lat!, lon!);
    
  }

  LatLng? pickedLocation;

  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Location Choosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isGettingLocation == true) {
      previewContent = CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                _getCurrentLocation();
              },
              icon: Icon(Icons.location_on),
              label: Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: () async {
                final pickedLocation = await Navigator.of(context).push<LatLng>(
                  MaterialPageRoute(
                    builder: (ctx) => MapScreen(),
                  ),
                );
                  _SavePlace(pickedLocation!.latitude, pickedLocation.longitude);
              },
              icon: Icon(Icons.map),
              label: Text("Select On Map"),
            ),
          ],
        )
      ],
    );
  }
}
