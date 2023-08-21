import 'dart:io';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.file(
                      file,
                      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImageEditorScreen(file: file), fullscreenDialog: true));
  }
}

//! The actual editor screen:

class TextEntry {
  String text;
  Offset position;

  TextEntry(this.text, this.position);
}

class ImageEditorScreen extends StatefulWidget {
  final File file;

  const ImageEditorScreen({Key? key, required this.file}) : super(key: key);

  @override
  ImageEditorScreenState createState() => ImageEditorScreenState();
}

class ImageEditorScreenState extends State<ImageEditorScreen> {
  double _rotation = 0;
  TextEditingController _textEditingController = TextEditingController();
  Mode _activeMode = Mode.none;
  List<List<Offset>> _allLines = [];
  List<Offset> _points = [];
  TransformationController _transformationController = TransformationController();
  GlobalKey _viewerKey = GlobalKey();

  List<TextEntry> _textEntries = [];
  Offset _textPosition = Offset(0, 0);
  bool _isTextMoving = false;
  Offset? _initialTouchOffset;

  // Stack for undo and redo
  List<EditorAction> _actionStack = [];
  List<EditorAction> _redoStack = [];

  void _pushAction(EditorAction action) {
    setState(() {
      _actionStack.add(action);
      _redoStack.clear(); // Clearing the redo stack whenever a new action is made
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CheckeredBackground(),
          Center(
            child: InteractiveViewer(
              key: _viewerKey,
              transformationController: _transformationController,
              panEnabled: _activeMode == Mode.none,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.1,
              maxScale: 2.0,
              child: Transform.rotate(
                angle: _rotation,
                child: Image.file(widget.file),
              ),
            ),
          ),
          Builder(
            builder: (context) => Stack(
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    if (_activeMode == Mode.painting) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        _points.add(renderBox.globalToLocal(details.globalPosition));
                      });
                    } else if (_isTextMoving) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        _textPosition = renderBox.globalToLocal(details.globalPosition);
                      });
                    }
                  },
                  onPanEnd: (details) {
                    if (_activeMode == Mode.painting) {
                      setState(() {
                        _allLines.add(List.from(_points));
                        _pushAction(EditorAction(actionType: ActionType.paint, points: _points));
                        _points.clear();
                      });
                    } else if (_isTextMoving) {
                      _isTextMoving = false;
                    }
                  },
                  child: CustomPaint(
                    painter: MyPainter(_allLines + [_points]),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                ..._textEntries
                    .map((entry) => Positioned(
                          left: entry.position.dx,
                          top: entry.position.dy,
                          child: GestureDetector(
                            onPanDown: (details) {
                              RenderBox renderBox = context.findRenderObject() as RenderBox;
                              _initialTouchOffset = renderBox.globalToLocal(details.globalPosition) - entry.position;
                              _isTextMoving = true;
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                RenderBox renderBox = context.findRenderObject() as RenderBox;
                                entry.position = renderBox.globalToLocal(details.globalPosition) - _initialTouchOffset!;
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              child: Text(
                                entry.text,
                                style: const TextStyle(color: Colors.black, fontSize: 24),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          if (_activeMode == Mode.textEditing)
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.black54, // dark background
                  width: MediaQuery.of(context).size.width, // full width
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textEditingController,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your text here',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                    onSubmitted: (value) {
                      RenderBox renderBox = _viewerKey.currentContext!.findRenderObject() as RenderBox;
                      Offset centerOfViewer = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
                      setState(() {
                        _textEntries.add(TextEntry(value, centerOfViewer));
                        _textEditingController.clear();
                        _activeMode = Mode.none;
                      });
                    },
                  ),
                ),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: _shadowedIcon(
              icon: Icon(CupertinoIcons.xmark, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Column(
              children: [
                _shadowedIcon(
                  icon: Icon(Icons.crop, color: Colors.white),
                  onPressed: () {},
                ),
                _shadowedIcon(
                  icon: Icon(Icons.rotate_right, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _rotation += 0.5;
                    });
                  },
                ),
                _shadowedIcon(
                  icon: Icon(Icons.rotate_left, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _rotation -= 0.5;
                    });
                  },
                ),
                _shadowedIcon(
                  icon: Icon(
                    Icons.text_fields,
                    color: _activeMode == Mode.textEditing ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_activeMode == Mode.textEditing) {
                        _activeMode = Mode.none;
                      } else {
                        _activeMode = Mode.textEditing;
                      }
                    });
                  },
                ),
                _shadowedIcon(
                  icon: Icon(
                    Icons.brush,
                    color: _activeMode == Mode.painting ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_activeMode == Mode.painting) {
                        _activeMode = Mode.none;
                      } else {
                        _activeMode = Mode.painting;
                      }
                    });
                  },
                ),
                _shadowedIcon(
                  icon: Icon(Icons.undo, color: Colors.white),
                  onPressed: () {
                    if (_allLines.isNotEmpty) {
                      setState(() {
                        _allLines.removeLast();
                      });
                    }
                  },
                ),
                _shadowedIcon(
                  icon: Icon(Icons.redo, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shadowedIcon({required Icon icon, required Function() onPressed}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Offset>> allLines;

  MyPainter(this.allLines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    for (final line in allLines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CheckeredBackground extends StatelessWidget {
  const CheckeredBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CheckeredPainter(),
    );
  }
}

class CheckeredPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLight = Paint()..color = Colors.grey[200]!;
    final paintDark = Paint()..color = Colors.grey[300]!;
    final double step = 20.0;

    for (var y = 0.0; y < size.height; y += step) {
      for (var x = 0.0; x < size.width; x += step) {
        final isDark = (x ~/ step + y ~/ step) % 2 == 1;
        final currentRect = Rect.fromLTWH(x, y, step, step);
        canvas.drawRect(currentRect, isDark ? paintDark : paintLight);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

enum Mode {
  none,
  textEditing,
  painting,
}

enum ActionType {
  paint,
  text,
}

class EditorAction {
  final ActionType actionType;
  final List<Offset>? points;
  final TextEntry? textEntry;

  EditorAction({required this.actionType, this.points, this.textEntry});
}
