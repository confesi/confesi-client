import 'dart:io';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/other/cached_online_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

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
  final List<File?> _selectedFiles = [];

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

  Future<void> _cropImage(File? file) async {
    if (file != null) {
      File? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x4,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          initAspectRatio: CropAspectRatioPreset.ratio5x4,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ),
      );

      setState(() {
        int index = _selectedFiles.indexOf(file);
        if (index != -1 && croppedFile != null) {
          _selectedFiles[index] = croppedFile;
        }
      });
    }
  }

  void _showEditor(File? file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Image.file(file!)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _selectedFiles.remove(file);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _cropImage(file);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ensures the children are left-aligned
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15),
                    ..._selectedFiles.map((file) {
                      return TouchableScale(
                        onLongPress: () {
                          setState(() {
                            _selectedFiles.remove(file);
                          });
                        },
                        onTap: () => _showEditor(file),
                        child: _buildFilePreview(file!),
                      );
                    }).toList(),
                    if (_selectedFiles.length < widget.maxImages)
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Align(
                              alignment: Alignment.center,
                              child: TouchableScale(
                                onTap: _selectFromGallery,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(CupertinoIcons.photo,
                                      size: 35.0, color: Theme.of(context).colorScheme.onSurface),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Align(
                              alignment: Alignment.center,
                              child: TouchableScale(
                                onTap: _selectFromCamera,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(CupertinoIcons.camera,
                                      size: 35.0, color: Theme.of(context).colorScheme.onSurface),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
            // if (_selectedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
              child: Text(
                "${_selectedFiles.length}/${widget.maxImages} images • long press to delete",
                style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(File file) {
    return Container(
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: 100.0,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            color: Colors.transparent,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(file),
            ),
          ),
        ),
      ),
    );
  }
}
