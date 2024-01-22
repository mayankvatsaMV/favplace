// import 'package:favplaces/screens/places_details.dart';
// import 'package:flutter/material.dart';
// import '../models/place.dart';

// class PlaceList extends StatelessWidget {
//   PlaceList({required this.places});
//   late final List<Place> places;
//   Widget build(BuildContext context) {
//     if (places.isEmpty) {
//       return Center(
//         child: Text("No Places Added yet",
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyLarge!
//                 .copyWith(color: Theme.of(context).colorScheme.onBackground)),
//       );
//     }
//     return ListView.builder(
//       itemCount: places.length,
//       itemBuilder: (ctx, index) => Padding(
//         padding: const EdgeInsets.only(top: 4,bottom: 2),
//         child: ListTile(
//           leading: CircleAvatar(
//             radius: 30,
//             backgroundImage: FileImage(places[index].image),
//           ),
//           title: Text(
//             places[index].title,
//             style: Theme.of(context)
//                 .textTheme
//                 .titleMedium!
//                 .copyWith(color: Theme.of(context).colorScheme.onBackground),
//           ),
//           subtitle: Text(
//             places[index].location.address,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodySmall!
//                 .copyWith(color: Theme.of(context).colorScheme.onBackground),
//           ),
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (ctx) => PlaceDetailScreen(place: places[index])));
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:favplaces/screens/places_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/place.dart';
import '../providers/user_places.dart';

class PlaceList extends ConsumerStatefulWidget {
  PlaceList({required this.places});
  late final List<Place> places;

  @override
  ConsumerState<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends ConsumerState<PlaceList> {
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          "No Places Added yet",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    Place? temp;
    int i;

    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: Dismissible(
          key: Key(widget.places[index].title), // Must be unique for each item
          background: Container(
            color: Colors.red, // Background color when swiping
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            // Remove the item from the data source (places list)
            // This should also update your backend or wherever the data is stored
            setState(() {
              temp = widget.places[index];
              i = index;
              widget.places.removeAt(index);
              // print("While swiping "+temp!.cat.toString());
              ref
                  .read(userplaceProvider.notifier)
                  .updateDataBase(temp!.id, temp!.title);
            });

            // Show a snackbar to indicate the item is removed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Place deleted"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    // You can implement undo logic here
                    // For simplicity, this example does not provide undo
                    setState(() {
                      // print("While undoing "+temp!.cat.toString());
                      // widget.places.add(temp!);
                      if (temp != null)
                        ref.read(userplaceProvider.notifier).addPlace(
                              temp!.title,
                              temp!.image,
                              temp!.location,
                              // temp!.cat,
                              temp!.cat,
                            );
                    });
                  },
                ),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: FileImage(widget.places[index].image),
            ),
            title: Text(
              widget.places[index].title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              widget.places[index].location.address,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            // trailing: Container(

            // ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      PlaceDetailScreen(place: widget.places[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
