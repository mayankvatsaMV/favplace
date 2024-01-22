import 'dart:io';

import 'package:favplaces/main.dart';
import 'package:favplaces/models/place.dart';
import 'package:favplaces/providers/user_places.dart';
import 'package:favplaces/widgets/image_input.dart';
import 'package:favplaces/widgets/location_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import '../models/category.dart';
import '../models/category.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
  AddPlaceScreen({super.key});
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? image;
  PlaceLocation? _selectedLocation;
  category? _selectedCategory;
  void getImage(File img) {
    image = img;
  }

  void _savePlace() {
    final enteredText = _titleController.text;
    if (enteredText.isEmpty) {
      // showDialog(context: context, builder: builder);
      return;
    }
    ref
        .read(userplaceProvider.notifier)
        .addPlace(enteredText, image!, _selectedLocation!,_selectedCategory!.name);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Place"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text(
                  "Title",
                ),
              ),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            DropdownButton<category>(
              value: _selectedCategory,
              onChanged: (category? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
              items: category.values.map((category category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                );
              }).toList(),
              dropdownColor: Color.fromARGB(255, 192, 39, 238),
            ),
            ImageInput(onPickImage: getImage),
            const SizedBox(
              height: 18,
            ),
            LocationInput(onSelectLocaion: (location) {
              _selectedLocation = location;
            }),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: Icon(Icons.add),
              label: const Text(
                "Add Place",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
