import 'package:favplaces/models/place.dart';
import 'package:favplaces/screens/map.dart';
import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});
  final Place place;
  String get locationImage {
    final lat = place!.location.latitude;
    final lon = place!.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lon=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:X%7C$lat,$lon&key=AIzaSyCtU_jg7SPwOnT2bPAFb0U-NQ__Z8IqPrE';
  }

  Widget build(BuildContext context) {
    print(place.cat);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 25)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(place.cat),
                  ),
                ],
      ),
      body: Stack(
        children: [
          // Text(
          //   place.title,
          //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //       color: Theme.of(context).colorScheme.onBackground,
          //       fontSize: 30),
          // ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Container(
                child: Image.file(
              place.image,
              fit: BoxFit.fill,
            )),
            decoration: BoxDecoration(
                // color: Colors.red,
                ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            location: place.location,
                            isSelecting: false,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationImage),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        place.location.address,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
