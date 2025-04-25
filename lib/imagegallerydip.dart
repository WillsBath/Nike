import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({Key? key}) : super(key: key);

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _showFullImage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Gallery")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _images.isEmpty
            ? const Center(
                child: Text(
                  "No images added yet!",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showFullImage(_images[index]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_images[index], fit: BoxFit.cover),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "camera",
            child: const Icon(Icons.camera),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "gallery",
            child: const Icon(Icons.photo_library),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final File image;
  const FullScreenImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}

/*
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^0.8.5+3 


  For Android, open android/app/src/main/AndroidManifest.xml and add the following permissions inside the <manifest> tag

  <uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

 */