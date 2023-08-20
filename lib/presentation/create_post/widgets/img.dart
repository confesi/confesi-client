import 'dart:io';
import 'package:confesi/presentation/shared/other/cached_online_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class Img extends StatefulWidget {
  final String? imageUrl;
  final File? fileImage;
  final EdgeInsets? padding;
  final VoidCallback? onDelete;

  const Img({Key? key, this.imageUrl, this.fileImage, this.padding, this.onDelete})
      : assert(imageUrl == null || fileImage == null),
        super(key: key);

  @override
  _ImgState createState() => _ImgState();
}

class _ImgState extends State<Img> {
  File? fileImage;

  @override
  void initState() {
    super.initState();
    fileImage = widget.fileImage;
  }

  Future<void> _cropImage() async {
    if (fileImage != null) {
      File? croppedFile = await ImageCropper().cropImage(
        sourcePath: fileImage!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x4,
        ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          initAspectRatio: CropAspectRatioPreset.ratio5x4,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
        ),
      );

      if (croppedFile != null) {
        setState(() {
          fileImage = croppedFile;
        });
      }
    } else {
      _selectFromGallery();
    }
  }

  Future<void> _selectFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        fileImage = File(pickedFile.path);
      });
      _showEditor();
    }
  }

  void _showEditor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: buildImg(context, isThumbnail: false)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        fileImage = null;
                      });
                      Navigator.of(context).pop();
                      if (widget.onDelete != null) {
                        widget.onDelete!();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _cropImage();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildImg(BuildContext context, {bool isThumbnail = true}) {
    Widget imageWidget;
    if (fileImage != null) {
      imageWidget = Image.file(fileImage!);
    } else if (widget.imageUrl != null) {
      imageWidget = CachedOnlineImage(url: widget.imageUrl!);
    } else {
      return IconButton(
        icon: Icon(Icons.add_photo_alternate, size: 50.0, color: Colors.grey[400]),
        onPressed: _selectFromGallery,
      );
    }

    if (isThumbnail) {
      return AspectRatio(
        aspectRatio: 1, // Ensure 1:1 for the thumbnail
        child: ClipRect(child: imageWidget),
      );
    }
    return ClipRect(child: imageWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showEditor,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(0),
        child: buildImg(context, isThumbnail: true),
      ),
    );
  }
}
