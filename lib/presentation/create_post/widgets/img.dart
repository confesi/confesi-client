import 'dart:io';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class Img extends StatefulWidget {
  const Img({
    Key? key,
    this.maxImages = 5,
  }) : super(key: key);

  final int maxImages;

  @override
  ImgState createState() => ImgState();
}

class ImgState extends State<Img> {
  final List<File> _selectedFiles = [];

  Future<void> _selectFromGallery() async {
    if (_selectedFiles.length >= widget.maxImages) {
      return;
    }
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedFiles.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _selectFromCamera() async {
    if (_selectedFiles.length >= widget.maxImages) {
      return;
    }
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedFiles.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).colorScheme.background,
        border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: ReorderableListView(
                  shrinkWrap: true,
                  onReorderStart: (_) => HapticFeedback.lightImpact(),
                  scrollDirection: Axis.horizontal,
                  onReorder: (int oldIndex, int newIndex) {
                    HapticFeedback.lightImpact();
                    _onReorder(oldIndex, newIndex);
                  },
                  children: <Widget>[
                    for (int index = 0; index < _selectedFiles.length; index++)
                      Material(
                        key: ValueKey(_selectedFiles[index]),
                        color: Colors.transparent, // Ensure this material is transparent.
                        child: ReorderableListener(
                          key: ValueKey(_selectedFiles[index]),
                          child: TouchableScale(
                            onTap: () {
                              if (_selectedFiles[index] != null) {
                                _showEditor(_selectedFiles[index]);
                              }
                            },
                            child: _buildFilePreview(_selectedFiles[index]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Add from gallery icon
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: _selectFromGallery,
              ),
              // Add from camera icon
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: _selectFromCamera,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > _selectedFiles.length) {
      newIndex = _selectedFiles.length;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final item = _selectedFiles.removeAt(oldIndex);
      _selectedFiles.insert(newIndex, item);
    });
  }

  Widget _buildFilePreview(File file) {
    return Material(
      color: Colors.transparent, // Ensure this material is transparent.
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
          borderRadius: BorderRadius.circular(15.0),
        ),
        height: 100.0,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(file),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditor(File? file) {
    if (file == null) return;
    // Sample ImageEditorScreen function, adapt accordingly to your needs
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageEditorScreen(file: file), fullscreenDialog: true));
  }
}

class ImageEditorScreen extends StatefulWidget {
  final File? file;

  const ImageEditorScreen({Key? key, required this.file}) : super(key: key);

  @override
  ImageEditorScreenState createState() => ImageEditorScreenState();
}

class ImageEditorScreenState extends State<ImageEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Here you can add the function to crop or edit the image.
                      // _cropImage(widget.file);
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
              ),
              child: widget.file != null ? Image.file(widget.file!) : SizedBox.shrink(),
            )),
          ],
        ),
      ),
    );
  }
}
