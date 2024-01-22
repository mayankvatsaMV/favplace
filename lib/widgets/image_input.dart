import 'dart:io';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ImageInput extends StatefulWidget {
  ImageInput({super.key, required this.onPickImage});
  Function(File) onPickImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  ImageSource? currentImageSource;
  void takePicture(var src) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: src,
      maxWidth: 600,
    );
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
      widget.onPickImage(_selectedImage!);
      // print(_selectedImage!.readAsBytes());
    });
  }

  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton.icon(
          icon: Icon(Icons.camera),
          label: Text("Take Picture"),
          onPressed: () {
            takePicture(ImageSource.camera);
            currentImageSource = ImageSource.camera;
          },
        ),
        TextButton.icon(
          icon: Icon(LineIcons.photoVideo),
          label: Text("Open Gallery"),
          onPressed: () {
            takePicture(ImageSource.gallery);
            currentImageSource = ImageSource.gallery;
          },
        ),
      ],
    );
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: () {
          takePicture(currentImageSource);
        },
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
      // content = GestureDetector(
      //   child: Image.network(_selectedImage!.path),
      // );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
