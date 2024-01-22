import 'dart:io';

import 'package:uuid/uuid.dart';

final uuid = const Uuid();

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;
  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
}

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
  // final Enum cat;
  final String cat;
  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
    required this.cat,
  }) : id = id ?? uuid.v4();
}
