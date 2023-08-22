import 'dart:io';
import 'dart:ui';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
  double scale;
  double rotation;

  TextEntry(this.text, this.position, {this.scale = 1.0, this.rotation = 0.0});
}

class ImageEditorScreen extends StatefulWidget {
  final File file;

  const ImageEditorScreen({Key? key, required this.file}) : super(key: key);

  @override
  ImageEditorScreenState createState() => ImageEditorScreenState();
}

class ImageEditorScreenState extends State<ImageEditorScreen> {
  final TransformationController _transformationController = TransformationController();
  final List<TextEntry> _textEntries = [];
  TextEntry? _editingTextEntry;
  final List<EditorAction> _actionStack = [];
  final List<EditorAction> _redoStack = [];
  Map<TextEntry, Tuple2<TextEditingController, FocusNode>> _textControllers = {};
  Mode _activeMode = Mode.none;
  final List<List<Offset>> _allLines = [];
  final List<Offset> _points = [];

  void _pushAction(EditorAction action) {
    _actionStack.add(action);
    _redoStack.clear();
  }

  @override
  void dispose() {
    for (var tuple in _textControllers.values) {
      tuple.item1.dispose();
      tuple.item2.dispose();
    }
    super.dispose();
  }

  Widget _buildEditableTransformedText({TextEntry? entry}) {
    bool isNewEntry = entry == null;
    final effectiveEntry = entry ??
        TextEntry(
          'Enter your text here!',
          Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2),
        );

    _textControllers[effectiveEntry] ??= Tuple2(TextEditingController(text: effectiveEntry.text), FocusNode());
    final TextEditingController currentController = _textControllers[effectiveEntry]!.item1;
    final FocusNode currentFocusNode = _textControllers[effectiveEntry]!.item2;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 50,
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              50,
        ),
        child: GestureDetector(
          onTap: () {
            _editingTextEntry = effectiveEntry;
            currentFocusNode.requestFocus();
            setState(() {});
          },
          child: Transform.rotate(
            angle: effectiveEntry.rotation,
            child: Transform.scale(
              scale: effectiveEntry.scale,
              child: EditableText(
                controller: currentController,
                focusNode: currentFocusNode,
                style: const TextStyle(color: Colors.black, fontSize: 24),
                cursorColor: Colors.black,
                backgroundCursorColor: Colors.green,
                maxLines: null,
                onSubmitted: (value) {
                  if (isNewEntry) {
                    setState(() {
                      _textEntries.add(effectiveEntry);
                      _activeMode = Mode.none;
                      currentFocusNode.unfocus();
                    });
                  } else {
                    setState(() {
                      effectiveEntry.text = value;
                      _activeMode = Mode.none;
                      _editingTextEntry = null;
                      currentFocusNode.unfocus();
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          if (_editingTextEntry != null) {
            setState(() {
              _editingTextEntry = null;
              _activeMode = Mode.none;
            });
          }
        },
        child: Stack(
          children: [
            CheckeredBackground(),
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _transformationController,
                panEnabled: _activeMode == Mode.none,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.1,
                maxScale: 2.0,
                child: Image.file(widget.file),
              ),
            ),
            Stack(
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    if (_activeMode == Mode.painting) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        _points.add(renderBox.globalToLocal(details.globalPosition));
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
                    }
                  },
                  child: CustomPaint(
                    painter: MyPainter(_allLines + [_points]),
                    child: const SizedBox.expand(),
                  ),
                ),
                for (var entry in _textEntries)
                  Positioned(
                    left: entry.position.dx,
                    top: entry.position.dy,
                    child: Draggable<TextEntry>(
                      maxSimultaneousDrags: 1,
                      data: entry,
                      feedback: _buildEditableTransformedText(entry: entry),
                      onDragEnd: (details) {
                        setState(() {
                          entry.position = details.offset;
                        });
                      },
                      childWhenDragging: Container(),
                      child: _buildEditableTransformedText(entry: entry),
                    ),
                  ),
              ],
            ),
            if (_activeMode == Mode.textEditing && _editingTextEntry == null) _buildEditableTransformedText(),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: _shadowedIcon(
                icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: Column(
                children: [
                  _shadowedIcon(
                    icon: const Icon(Icons.brush, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _activeMode = Mode.painting;
                      });
                    },
                  ),
                  _shadowedIcon(
                    icon: const Icon(Icons.text_fields, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _activeMode = Mode.textEditing;
                      });
                    },
                  ),
                  _shadowedIcon(
                    icon: const Icon(Icons.undo, color: Colors.white),
                    onPressed: () {
                      if (_actionStack.isNotEmpty) {
                        setState(() {
                          EditorAction lastAction = _actionStack.removeLast();
                          if (lastAction.actionType == ActionType.paint) {
                            _allLines.remove(lastAction.points);
                          }
                          _redoStack.add(lastAction);
                        });
                      }
                    },
                  ),
                  _shadowedIcon(
                    icon: const Icon(Icons.redo, color: Colors.white),
                    onPressed: () {
                      if (_redoStack.isNotEmpty) {
                        setState(() {
                          EditorAction lastAction = _redoStack.removeLast();
                          if (lastAction.actionType == ActionType.paint) {
                            _allLines.add(lastAction.points!);
                          }
                          _actionStack.add(lastAction);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shadowedIcon({required Icon icon, required Function() onPressed}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Offset>> allLines;

  MyPainter(this.allLines);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (var line in allLines) {
      for (var i = 0; i < line.length - 1; i++) {
        if (line[i] != null && line[i + 1] != null) canvas.drawLine(line[i], line[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class EditorAction {
  final ActionType actionType;
  final List<Offset>? points;

  EditorAction({required this.actionType, this.points});
}

enum ActionType {
  paint,
  text,
}

enum Mode {
  none,
  painting,
  textEditing,
}

class CheckeredBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int rows = (constraints.maxHeight / 20).ceil();
        final int columns = (constraints.maxWidth / 20).ceil();
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 20,
          ),
          itemBuilder: (context, index) {
            bool isOddRow = (index / rows).floor().isOdd;
            bool isOddColumn = (index % columns).isOdd;
            return Container(
              color: (isOddRow && !isOddColumn) || (!isOddRow && isOddColumn) ? Colors.grey[300] : Colors.grey[200],
            );
          },
        );
      },
    );
  }
}
