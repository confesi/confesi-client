import 'dart:io';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/create_post/widgets/moveable.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:scrollable/exports.dart';
import 'package:tuple/tuple.dart';

import '../../shared/edited_source_widgets/matrix_gesture_detector.dart';

class ImgController extends ChangeNotifier {
  late ImgState _imgState;

  void _attach(ImgState state) {
    _imgState = state;
    notifyListeners();
  }

  Future<void> selectFromGallery() async {
    await _imgState._selectFromGallery();
    FocusManager.instance.primaryFocus?.unfocus();
    notifyListeners();
  }

  void scrollToEnd() {
    _imgState._scrollToEnd();
    notifyListeners();
  }

  Future<void> selectFromCamera() async {
    await _imgState._selectFromCamera();
    FocusManager.instance.primaryFocus?.unfocus();
    notifyListeners();
  }

  void notify() => notifyListeners();

  List<File> get images => _imgState._images;
}

class Img extends StatefulWidget {
  final ImgController? controller;
  final int maxImages;

  const Img({
    Key? key,
    this.controller,
    this.maxImages = 5,
  }) : super(key: key);

  @override
  ImgState createState() => ImgState();
}

class ImgState extends State<Img> {
  final List<File> _images = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.controller?._attach(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void _animateToEndOfScrollview() {
    widget.controller!._imgState.scrollController.animateTo(
        widget.controller!._imgState.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut);
  }

  Future<void> _selectFromGallery() async {
    if (_images.length >= widget.maxImages) {
      context.read<NotificationsCubit>().showErr("Max images reached");
      return;
    }
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null && _images.length < widget.maxImages) {
      setState(() {
        _images.add(File(pickedFile.path));
        widget.controller!.notify();
      });
    }
    await Future.delayed(const Duration(milliseconds: 250)).then((value) => _animateToEndOfScrollview());
  }

  Future<void> _selectFromCamera() async {
    if (_images.length >= widget.maxImages) {
      context.read<NotificationsCubit>().showErr("Max images reached");
      return;
    }
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null && _images.length < widget.maxImages) {
      setState(() {
        _images.add(File(pickedFile.path));
        widget.controller!.notify();
      });
    }
    await Future.delayed(const Duration(milliseconds: 250)).then((value) => _animateToEndOfScrollview());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: _images.isEmpty ? 0 : 15),
        height: widget.controller != null && _images.isNotEmpty ? 100 : 0,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 15), // SizedBox at the start

              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: ReorderableListView(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  onReorderStart: (_) => HapticFeedback.lightImpact(),
                  scrollDirection: Axis.horizontal,
                  onReorder: (int oldIndex, int newIndex) {
                    HapticFeedback.lightImpact();
                    _onReorder(oldIndex, newIndex);
                  },
                  children: <Widget>[
                    for (int index = 0; index < _images.length; index++)
                      TouchableScale(
                        key: ValueKey(index),
                        onTap: () => _showEditor(_images[index]),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: _buildFilePreview(_images[index], index),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // SizedBox at the end
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_images.length}/${widget.maxImages} images',
                    style: kDetail.copyWith(
                      color: _images.length == widget.maxImages
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10), // SizedBox at the end
                  Text(
                    'Hold + drag to reorder',
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(width: 15), // SizedBox at the end
            ],
          ),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final item = _images.removeAt(oldIndex);

      _images.insert(newIndex, item);
      widget.controller!.notify();
    });
  }

  void _scrollToEnd() {
    if (_images.isNotEmpty) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildFilePreview(File file, int index) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.file(
                      file,
                      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1, // Only animate the opacity if an image frame is available
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 5,
          right: 5,
          child: TouchableScale(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.error,
              radius: 15.0, // Adjust the size of the circle as needed
              child: Icon(
                CupertinoIcons.trash,
                color: Theme.of(context).colorScheme.onError,
                size: 15.0,
              ),
            ),
            onTap: () {
              setState(() {
                _images.removeAt(index);
                widget.controller!.notify();
              });
            },
          ),
        ),
      ],
    );
  }

  void _showEditor(File file) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImageEditorScreen(file: file), fullscreenDialog: false)); // todo: full-screen: true
  }
}

//! The actual editor screen:

class TextEntry {
  String text;
  Matrix4 matrix;
  double fontSize;

  TextEntry(this.text, {this.fontSize = 14.0}) : matrix = Matrix4.identity();
}

class ImageEditorScreen extends StatefulWidget {
  final File file;

  const ImageEditorScreen({Key? key, required this.file}) : super(key: key);

  @override
  ImageEditorScreenState createState() => ImageEditorScreenState();
}

class ImageEditorScreenState extends State<ImageEditorScreen> {
  final List<TextEntry> _textEntries = [];
  final Map<TextEntry, Tuple3<TextEditingController, FocusNode, double>> _textControllers = {};

  FocusNode? _currentFocusedField;
  bool get _showFontSizeSlider => _currentFocusedField != null;
  FocusAttachment? _focusAttachment; // Declare this at the class level

  FocusNode _createFocusNode() {
    final node = FocusNode();
    _focusAttachment = node.attach(context); // Attach the focus node
    node.addListener(() {
      setState(() {
        if (node.hasFocus) {
          _focusAttachment?.reparent();
          _currentFocusedField = node;
        } else if (_currentFocusedField == node) {
          _focusAttachment?.detach();
          _currentFocusedField = null;
        }
      });
    });
    return node;
  }

  @override
  void dispose() {
    for (var tuple in _textControllers.values) {
      tuple.item1.dispose();
      tuple.item2.dispose();
    }
    super.dispose();
  }

  Widget _buildText(BuildContext context, TextEditingController controller, FocusNode focusNode, double fontSize,
      {void Function()? onEditingComplete}) {
    return GestureDetector(
      onTap: () {
        _currentFocusedField?.unfocus();
        FocusScope.of(context).requestFocus(focusNode);
        setState(() {
          _currentFocusedField = focusNode;
        });
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: IgnorePointer(
                ignoring: !focusNode.hasFocus,
                child: TextField(
                  scrollPadding: EdgeInsets.zero,
                  maxLines: null,
                  decoration: InputDecoration(
                    isDense: true, // Add this line
                    contentPadding: EdgeInsets.zero, // Removes internal padding
                    border: InputBorder.none,
                    hintText: 'Enter text',
                    hintStyle: kBody.copyWith(color: Colors.black, fontSize: fontSize),
                  ),
                  style: kBody.copyWith(color: Colors.black, fontSize: fontSize),
                  textAlign: TextAlign.center,
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTransformedText(TextEntry entry) {
    _textControllers[entry] ??= Tuple3(TextEditingController(text: entry.text), _createFocusNode(), entry.fontSize);
    final currentController = _textControllers[entry]!.item1;
    final currentFocusNode = _textControllers[entry]!.item2;
    final currentFontSize = _textControllers[entry]!.item3;

    return Moveable(
      onDragEnd: (offset) {},
      onDragStart: (offset) {},
      onDragUpdate: (offset) {},
      initialMatrix: entry.matrix,
      onMatrixChange: (m) => setState(() => entry.matrix = m),
      child: _buildText(
        context,
        currentController,
        currentFocusNode,
        currentFontSize,
        onEditingComplete: () {
          entry.text = currentController.text;
        },
      ),
    );
  }

  TextEntry? _getCurrentEntry() {
    for (var entry in _textEntries) {
      if (_textControllers[entry]!.item2 == _currentFocusedField) {
        return entry;
      }
    }
    return null; // or return _textEntries.first; if you want a default
  }

  Widget buildSlider(BuildContext context) {
    if (_currentFocusedField != null && _showFontSizeSlider) {
      return RotatedBox(
        key: const ValueKey("slider"),
        quarterTurns: 3,
        child: Slider(
          focusNode: AlwaysDisabledFocusNode(), // Add this
          value: _textControllers[_getCurrentEntry()]!.item3,
          onChanged: (value) {
            setState(() {
              TextEntry? currentEntry = _getCurrentEntry();
              if (currentEntry != null) {
                // only proceed if we have a valid entry
                Tuple3<TextEditingController, FocusNode, double> currentTuple = _textControllers[currentEntry]!;
                currentTuple = Tuple3(
                  currentTuple.item1,
                  currentTuple.item2,
                  value,
                );
                _textControllers[currentEntry] = currentTuple;
                currentEntry.fontSize = value;
              }
            });
          },
          min: 10.0,
          max: 40.0,
        ),
      );
    } else {
      return const SizedBox(
        key: ValueKey("sizedbox"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: KeyboardDismiss(
              child: Image.file(widget.file, fit: BoxFit.contain),
            ),
          ),
          ..._textEntries.map((entry) => _buildEditableTransformedText(entry)).toList(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _textEntries.add(TextEntry('New Text'));
                  });
                },
                child: const Text('Add Text'),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 150,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: buildSlider(context),
            ),
          )
        ],
      ),
    );
  }
}

// Outside your class, create this:
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
