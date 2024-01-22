// import 'package:favplaces/providers/user_places.dart';
// import 'package:favplaces/screens/add_place.dart';
// import 'package:favplaces/widgets/places_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class PlacesScreen extends ConsumerStatefulWidget {
//   const PlacesScreen({super.key});
//   @override
//   ConsumerState<PlacesScreen> createState() {
//     // TODO: implement createState
//     return _PlaceScreenState();
//   }
// }

// class _PlaceScreenState extends ConsumerState<PlacesScreen> {
//   late Future<void> _placesfuture;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _placesfuture = ref.read(userplaceProvider.notifier).loadPlaces();
//   }

//   void _showSortOptions(BuildContext context) async {
//     var width=MediaQuery.of(context).size.width;
//     var height=MediaQuery.of(context).size.height;
//     final selectedSort = await showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(width, height*0.75, 0, 0),
//       items: [
//         PopupMenuItem(value: 'name', child: Text('Sort by Name'),),
//         PopupMenuItem(value: 'category', child: Text('Sort by Category')),
//       ],
//     );

//     if (selectedSort != null) {
//       // Handle the selected sort option
//       // You can call a sorting function here based on the selected value
//       if (selectedSort == 'name') {
//         // Sort by name
//       } else if (selectedSort == 'category') {
//         // Sort by category
//       }
//     }
//   }

//   Widget build(BuildContext context) {
//     final userPlaces = ref.watch(userplaceProvider);
//     // print("while loading at start"+userPlaces[0].cat.toString());
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("your Place"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (ctx) => AddPlaceScreen(),
//                   ),
//                 );
//               },
//               icon: Icon(Icons.add))
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 10),
//         child: FutureBuilder(
//           future: _placesfuture,
//           builder: (context, snapshot) =>
//               snapshot.connectionState == ConnectionState.waiting
//                   ? Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : PlaceList(
//                       places: userPlaces,
//                     ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             _showSortOptions(context);
//           },
//           child: Icon(Icons.sort)),
//     );
//   }
// }

import 'package:favplaces/providers/user_places.dart';
import 'package:favplaces/screens/add_place.dart';
import 'package:favplaces/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});
  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlaceScreenState();
  }
}

class _PlaceScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;
  bool _isMenuOpen = false;
  late var userPlaces;
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userplaceProvider.notifier).loadPlaces();
    // userPlaces = ref.watch(userplaceProvider);
  }

  void _showSortOptions(BuildContext context) async {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final selectedSort = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(width, height * 0.75, 0, 0),
      items: [
        PopupMenuItem(value: 'name', child: Text('Sort by Name')),
        PopupMenuItem(value: 'category', child: Text('Sort by Category')),
      ],
    );

    if (selectedSort != null) {
      // Handle the selected sort option
      // You can call a sorting function here based on the selected value
      if (selectedSort == 'name') {
        // Sort by name
        setState(() {
          // sortByName();
          userPlaces = ref.watch(userplaceProvider);
          userPlaces.sort((a, b) => a.title.compareTo(b.title) as int);
          _isMenuOpen=false;
        });
      } else if (selectedSort == 'category') {
        // Sort by category
      }
    }

    // Set the state to indicate that the menu is closed
    setState(() {
      _isMenuOpen = false;
    });
  }

  Widget build(BuildContext context) {
    userPlaces = ref.watch(userplaceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddPlaceScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : PlaceList(
                      places: userPlaces,
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Toggle the menu state
          setState(() {
            _isMenuOpen = !_isMenuOpen;
          });

          // Show/hide the menu based on the state
          if (_isMenuOpen) {
            _showSortOptions(context);
          }
        },
        child: _isMenuOpen ? Icon(Icons.cancel) : Icon(Icons.sort),
      ),
    );
  }
}
