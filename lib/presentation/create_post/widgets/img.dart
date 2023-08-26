import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrollable/exports.dart';
import 'package:tuple/tuple.dart';

import '../../shared/edited_source_widgets/matrix_gesture_detector.dart';

// todo: preview mode that hides all editing options while held down

class Moveable extends StatefulWidget {
  final Matrix4 initialMatrix;
  final Widget child;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final Function(Matrix4 matrix, Offset offset) onMatrixChange;
  final bool isDraggable;

  const Moveable({
    Key? key,
    required this.child,
    required this.onDragStart,
    required this.onDragEnd,
    required this.initialMatrix,
    required this.onMatrixChange,
    this.isDraggable = true,
  }) : super(key: key);

  @override
  MoveableState createState() => MoveableState();
}

class MoveableState extends State<Moveable> {
  late ValueNotifier<Matrix4> notifier;

  @override
  void initState() {
    super.initState();
    notifier = ValueNotifier(widget.initialMatrix);
  }

  @override
  void didUpdateWidget(covariant Moveable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMatrix != widget.initialMatrix) {
      notifier.value = widget.initialMatrix;
    }
  }

  Offset _getCenterPosition(Matrix4 matrix, Size size) {
    final transformedCenter = matrix.transform3(v.Vector3(size.width / 2, size.height / 2, 0));
    return Offset(transformedCenter.x, transformedCenter.y);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return IgnorePointer(
      ignoring: !widget.isDraggable,
      child: Listener(
        child: MatrixGestureDetector(
          onScaleEnd: widget.onDragEnd,
          onScaleStart: widget.onDragStart,
          shouldTranslate: true,
          shouldScale: true,
          shouldRotate: true,
          onMatrixUpdate: (m, tm, sm, rm) {
            if (!widget.isDraggable) return;

            // Combine the current matrix with the transformation matrix
            final combinedMatrix = notifier.value * tm;

            var centerPos = _getCenterPosition(combinedMatrix, screenSize);
            notifier.value = combinedMatrix;
            widget.onMatrixChange(combinedMatrix, centerPos);
          },
          child: Transform(
            transform: notifier.value,
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.contain,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class CheckeredBackground extends StatelessWidget {
  final double squareSize;
  final Color color1;
  final Color color2;

  const CheckeredBackground({super.key, this.squareSize = 45.0, required this.color1, required this.color2});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: CheckeredPainter(squareSize, color1, color2),
    );
  }
}

class CheckeredPainter extends CustomPainter {
  final double squareSize;
  final Color color1;
  final Color color2;

  CheckeredPainter(this.squareSize, this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint blackPaint = Paint()..color = color1;
    final Paint whitePaint = Paint()..color = color2;

    // Calculate the number of squares for width and height
    int widthCount = (size.width / squareSize).ceil();
    int heightCount = (size.height / squareSize).ceil();

    for (int i = 0; i < widthCount; i++) {
      for (int j = 0; j < heightCount; j++) {
        bool isBlackSquare = (i + j) % 2 == 0;
        final offset = Offset(i * squareSize, j * squareSize);
        final rect = Rect.fromLTWH(offset.dx, offset.dy, squareSize, squareSize);

        if (isBlackSquare) {
          canvas.drawRect(rect, blackPaint);
        } else {
          canvas.drawRect(rect, whitePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImageEditorScreen(file: file), fullscreenDialog: true));
  }
}

//! The actual editor screen:

enum ColorSet { black, white, red }

Map<ColorSet, Tuple2<Color, Color>> colorMap = {
  ColorSet.black: const Tuple2<Color, Color>(Colors.black, Colors.white),
  ColorSet.white: const Tuple2<Color, Color>(Colors.white, Colors.black),
  ColorSet.red: const Tuple2<Color, Color>(Colors.red, Colors.white),
};

Tuple2<Color, Color> getColorsForSet(ColorSet colorSet) {
  final res = colorMap[colorSet];
  if (res == null) throw Exception("ColorSet not found");
  return colorMap[colorSet]!;
}

class TextEntry {
  String text;
  Matrix4 matrix;
  double fontSize;
  bool hasBg;
  bool isBold;
  ColorSet colorSet;
  Offset offset;

  // clone method
  TextEntry clone() {
    return TextEntry(
      text,
      fontSize: fontSize,
      hasBg: hasBg,
      isBold: isBold,
      colorSet: colorSet,
      offset: offset,
    );
  }

  TextEntry(this.text,
      {this.fontSize = 30.0,
      this.hasBg = true,
      this.isBold = true,
      this.colorSet = ColorSet.white,
      this.offset = Offset.zero})
      : matrix = Matrix4.identity();
}

class Line {
  Offset offset;
  bool isBig;
  ColorSet colorSet;

  Line(this.offset, this.isBig, this.colorSet);
}

class ImageEditorScreen extends StatefulWidget {
  final File file;

  const ImageEditorScreen({Key? key, required this.file}) : super(key: key);

  @override
  ImageEditorScreenState createState() => ImageEditorScreenState();
}

class ImageEditorScreenState extends State<ImageEditorScreen> {
  bool paintBrushBig = false;
  ColorSet paintBrushColorSet = ColorSet.red;

  late File editingFile;

  List<TextEntry> _textEntries = [];
  Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>> _textControllers = {};

  FocusNode? _currentFocusedField;
  bool get _showFontSizeSlider => _currentFocusedField != null;
  FocusAttachment? _focusAttachment;
  HashSet<TextEntry> currentDraggingEntries = HashSet();
  List<
      Tuple3<List<TextEntry>, Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>>,
          List<List<Line>>>> _undoStack = [];
  List<
      Tuple3<List<TextEntry>, Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>>,
          List<List<Line>>>> _redoStack = [];

  bool isDrawingMode = false;
  List<List<Line>> lines = [];

  void _beforeChange() {
    _undoStack.add(Tuple3(_textEntries.map((e) => e.clone()).toList(), _deepCopyTextControllers(_textControllers),
        lines.isNotEmpty ? lines.map<List<Line>>((line) => List<Line>.from(line)).toList() : []));
    _redoStack.clear();
  }

  void _refreshState() {
    setState(() {});
  }

  bool hasDoneHapticForDeleteAlready = false;

  Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>> _deepCopyTextControllers(
      Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>> original) {
    Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>> copy = {};

    original.forEach((key, value) {
      copy[key] = Tuple4(
          TextEditingController(text: value.item1.text),
          FocusNode(), // Creating a new focus node, if you have a different behavior in mind, adjust this
          value.item3,
          value.item4);
    });

    return copy;
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _moveCurrentStateToRedoStack();
    _restoreStateFromUndoStack();
    _updateUI();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _moveCurrentStateToUndoStack();
    _restoreStateFromRedoStack();
    _updateUI();
  }

  void _moveCurrentStateToRedoStack() {
    _redoStack.add(Tuple3(List.from(_textEntries), Map.from(_textControllers), List.from(lines)));
  }

  void _moveCurrentStateToUndoStack() {
    _undoStack.add(Tuple3(List.from(_textEntries), Map.from(_textControllers), List.from(lines)));
  }

  void _restoreStateFromUndoStack() {
    if (_undoStack.isNotEmpty) {
      final lastState = _undoStack.removeLast();
      _textEntries = lastState.item1;
      _textControllers = _deepCopyTextControllers(lastState.item2);
      lines = lastState.item3.map<List<Line>>((line) => List<Line>.from(line)).toList();

      _refreshState();
    }
  }

  void _restoreStateFromRedoStack() {
    if (_redoStack.isNotEmpty) {
      final nextState = _redoStack.removeLast();
      _textEntries = nextState.item1;
      _textControllers = _deepCopyTextControllers(nextState.item2);
      lines = nextState.item3.map<List<Line>>((line) => List<Line>.from(line)).toList();

      _refreshState();
    }
  }

  void _updateUI() {
    setState(() {});
  }

  FocusNode _createFocusNode() {
    final node = FocusNode();
    _focusAttachment = node.attach(context);
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

  bool _isImageLoaded = false;

  @override
  initState() {
    super.initState();
    editingFile = widget.file;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger rebuild after the first frame
      if (!_isImageLoaded) {
        setState(() {
          _isImageLoaded = true;
        });
      }
    });
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
      bool hasBg, bool isBold, ColorSet colorSet, TextEntry t,
      {void Function()? onEditingComplete}) {
    Tuple2<Color, Color> colors = getColorsForSet(colorSet);

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
            // Add padding dynamically based on keyboard visibility and widget position.
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: hasBg ? colors.item1 : Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: IgnorePointer(
                ignoring: !focusNode.hasFocus,
                child: TextField(
                  cursorColor: colors.item2,
                  // scrollPadding: EdgeInsets.zero,
                  maxLines: null,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'text',
                    hintStyle: TextStyle(
                        color: colors.item2,
                        fontSize: fontSize,
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
                  ),
                  style: TextStyle(
                      color: colors.item2,
                      fontSize: fontSize,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
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

  bool thereIsSomeEntryInDeletionBoundary() {
    bool res = false;
    for (var entry in _textControllers.keys) {
      if (_textControllers[entry]!.item4.dy > heightFraction(context, 14 / 16) &&
          _textControllers[entry]!.item4.dx > widthFraction(context, 1 / 4) &&
          _textControllers[entry]!.item4.dx < widthFraction(context, 3 / 4)) {
        res = true;
      }
    }
    if (res && !hasDoneHapticForDeleteAlready) {
      hasDoneHapticForDeleteAlready = true;
      HapticFeedback.lightImpact();
    }
    if (!res) {
      hasDoneHapticForDeleteAlready = false;
    }
    return res;
  }

  Widget _buildEditableTransformedText(TextEntry entry, double bottomInsetHeight) {
    _textControllers[entry] ??=
        Tuple4(TextEditingController(text: entry.text), _createFocusNode(), entry.fontSize, entry.offset);
    final currentController = _textControllers[entry]!.item1;
    final currentFocusNode = _textControllers[entry]!.item2;
    final currentFontSize = _textControllers[entry]!.item3;

    bool isEntryInDeletionBoundary() {
      final Offset off = _textControllers[entry]!.item4;
      if (off.dy > heightFraction(context, 14 / 16) &&
          off.dx > widthFraction(context, 1 / 4) &&
          off.dx < widthFraction(context, 3 / 4)) {
        return true;
      }
      return false;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 62),
      opacity: isEntryInDeletionBoundary() ? 0.5 : 1,
      child: Moveable(
        initialMatrix: entry.matrix,
        isDraggable: currentDraggingEntries.contains(entry) || currentDraggingEntries.isEmpty,
        onDragEnd: () {
          if (!currentDraggingEntries.contains(entry)) return;
          currentDraggingEntries.remove(entry);
          if (isEntryInDeletionBoundary()) {
            setState(() {
              _textControllers.remove(entry);
              _textEntries.remove(entry);
            });
          }
        },
        onDragStart: () {
          if (currentDraggingEntries.contains(entry)) return;
          _beforeChange();
          FocusManager.instance.primaryFocus?.unfocus();
          currentDraggingEntries.add(entry);
        },
        onMatrixChange: (m, o) {
          if (currentDraggingEntries.isNotEmpty && !currentDraggingEntries.contains(entry)) return;
          setState(() {
            _textControllers[entry] = Tuple4(
              _textControllers[entry]!.item1,
              _textControllers[entry]!.item2,
              _textControllers[entry]!.item3,
              o,
            );
            entry.offset = o;
            entry.matrix = m;
          });
        },
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 62),
          tween: Tween<double>(begin: 1, end: isEntryInDeletionBoundary() ? 0.5 : 1),
          builder: (BuildContext context, double scaleValue, Widget? child) {
            return Transform.scale(
              scale: scaleValue,
              child: child,
            );
          },
          child: _buildText(
            context,
            currentController,
            currentFocusNode,
            currentFontSize,
            entry.hasBg,
            entry.isBold,
            entry.colorSet,
            entry,
            onEditingComplete: () {
              entry.text = currentController.text;
            },
          ),
        ),
      ),
    );
  }

  TextEntry? _getCurrentEntry() {
    for (var entry in _textControllers.keys) {
      if (_textControllers[entry]!.item2 == _currentFocusedField) {
        return entry;
      }
    }
    return null;
  }

  Widget buildSlider(BuildContext context) {
    if (_currentFocusedField != null && _showFontSizeSlider) {
      return RotatedBox(
        key: const ValueKey("slider"),
        quarterTurns: 3,
        child: Column(
          children: [
            Slider(
              thumbColor: Theme.of(context).colorScheme.secondary,
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.onBackground,
              focusNode: AlwaysDisabledFocusNode(),
              value: _textControllers[_getCurrentEntry()]!.item3,
              onChanged: (value) {
                setState(() {
                  TextEntry? currentEntry = _getCurrentEntry();
                  if (currentEntry != null) {
                    Tuple4<TextEditingController, FocusNode, double, Offset> currentTuple =
                        _textControllers[currentEntry]!;
                    currentTuple = Tuple4(
                      currentTuple.item1,
                      currentTuple.item2,
                      value,
                      currentTuple.item4,
                    );
                    _textControllers[currentEntry] = currentTuple;
                    currentEntry.fontSize = value;
                  }
                });
              },
              min: 18.0,
              max: 60.0,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox(
        key: ValueKey("sizedbox"),
      );
    }
  }

  // drawing menu (has color, size)

  Widget buildDrawingSettingsMenu(BuildContext context) {
    if (!isDrawingMode || isDrawing) return const SizedBox.shrink();
    return SizedBox(
      key: const ValueKey("options"),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            CircleIconBtn(
              hasBorder: true,
              isBig: true,
              onTap: () {
                setState(() {
                  paintBrushBig = !paintBrushBig;
                });
              },
              icon: paintBrushBig ? CupertinoIcons.largecircle_fill_circle : CupertinoIcons.smallcircle_fill_circle,
            ),
            const SizedBox(width: 8),
            CircleIconBtn(
              color: getColorsForSet(paintBrushColorSet).item1,
              hasBorder: true,
              isBig: true,
              onTap: () {
                setState(() {
                  if (paintBrushColorSet == ColorSet.black) {
                    paintBrushColorSet = ColorSet.white;
                  } else if (paintBrushColorSet == ColorSet.white) {
                    paintBrushColorSet = ColorSet.red;
                  } else {
                    paintBrushColorSet = ColorSet.black;
                  }
                });
              },
              icon: CupertinoIcons.color_filter,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget buildTextSettingsMenu(BuildContext context) {
    TextEntry? currentEntry = _getCurrentEntry();

    if (currentEntry != null) {
      return SizedBox(
        key: const ValueKey("options"),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8),
              CircleIconBtn(
                hasBorder: false,
                isBig: true,
                onTap: () {
                  setState(() {
                    if (currentEntry.colorSet == ColorSet.black) {
                      currentEntry.colorSet = ColorSet.white;
                    } else if (currentEntry.colorSet == ColorSet.white) {
                      currentEntry.colorSet = ColorSet.red;
                    } else {
                      currentEntry.colorSet = ColorSet.black;
                    }
                  });
                },
                icon: CupertinoIcons.color_filter,
                color: getColorsForSet(currentEntry.colorSet).item2,
                bgColor: getColorsForSet(currentEntry.colorSet).item1,
              ),
              const SizedBox(width: 8),
              CircleIconBtn(
                isBig: true,
                isSelected: currentEntry.isBold,
                onTap: () {
                  setState(() {
                    currentEntry.isBold = !currentEntry.isBold;
                  });
                },
                icon: CupertinoIcons.bold,
              ),
              const SizedBox(width: 8),
              CircleIconBtn(
                isBig: true,
                isSelected: currentEntry.hasBg,
                onTap: () {
                  setState(() {
                    currentEntry.hasBg = !currentEntry.hasBg;
                  });
                },
                icon: CupertinoIcons.square_fill_on_square_fill,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink(
      key: ValueKey("filler"),
    );
  }

  bool isDrawing = false;

  final GlobalKey _repaintKey = GlobalKey();

  /// Returns true if the image was saved successfully, else false.
  Future<bool> _captureAndSaveImage(BuildContext context) async {
    RenderRepaintBoundary boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    return await image.toByteData(format: ui.ImageByteFormat.png).then(
      (ByteData? byteData) async {
        if (byteData == null) {
          return false;
        }
        Uint8List uint8list = byteData!.buffer.asUint8List();

        // Save to gallery
        final result = await ImageGallerySaver.saveImage(uint8list, quality: 9999999999);
        if (result['isSuccess']) {
          return true;
        } else {
          return false;
        }
      },
    );
  }

  bool isErasing = false;

  void _eraseLine(Offset globalPosition) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(globalPosition);

    bool shouldErase = lines.any((line) {
      for (Line point in line) {
        if ((point.offset - localPosition).distance < 15) {
          return true;
        }
      }
      return false;
    });

    if (shouldErase) {
      _beforeChange();
      setState(() {
        lines.removeWhere((line) {
          for (Line point in line) {
            if ((point.offset - localPosition).distance < 15) {
              return true;
            }
          }
          return false;
        });
      });
    }
  }

  Offset? _eraserPosition; // this is the pos of the eraser indicator, not the actual eraser itself
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      resizeToAvoidBottomInset: true, // todo: alter?
      body: SingleChildScrollView(
        physics: const NeverUserScrollablePhysics(),
        child: Stack(
          children: [
            CheckeredBackground(
              color1: Theme.of(context).colorScheme.tertiary,
              color2: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
            ),
            Positioned.fill(child: _getCurrentEntry() != null ? Container() : const SizedBox.shrink()),
            SizedBox(
              height: heightFraction(context, 1),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final RenderBox? imageRenderBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
                  final double imageHeight = imageRenderBox?.size.height ?? 0;
                  final double imageWidth = imageRenderBox?.size.width ?? 0;

                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.file(editingFile, fit: BoxFit.fitWidth, key: _imageKey),
                      ),
                      Positioned.fill(child: CustomPaint(painter: DrawingPainter(lines))),
                      !isDrawingMode && !isErasing
                          ? const Positioned.fill(child: KeyboardDismiss(child: SizedBox.expand()))
                          : const SizedBox.shrink(),
                      ..._textEntries
                          .map((entry) => Positioned.fill(child: _buildEditableTransformedText(entry, keyboardHeight)))
                          .toList(),
                      // Use the image's dimensions to delineate the boundaries of the repaint area
                      IgnorePointer(
                        ignoring: true,
                        child: Center(
                          child: RepaintBoundary(
                            key: _repaintKey,
                            child: Container(
                              height: imageHeight,
                              width: imageWidth,
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  Image.file(editingFile, fit: BoxFit.fitWidth),
                                  CustomPaint(painter: DrawingPainter(lines)),
                                  ..._textEntries
                                      .map((entry) => _buildEditableTransformedText(entry, keyboardHeight))
                                      .toList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(top: MediaQuery.of(context).size.height / 2 - 150, child: buildSlider(context)),
            isErasing
                ? Positioned.fill(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onPanStart: (details) {
                              _eraseLine(details.globalPosition);
                              setState(() {
                                _eraserPosition = details.localPosition;
                              });
                            },
                            onPanUpdate: (details) {
                              _eraseLine(details.globalPosition);
                              setState(() {
                                _eraserPosition = details.localPosition;
                              });
                            },
                            onPanEnd: (details) {
                              setState(() {
                                _eraserPosition = null;
                              });
                            },
                          ),
                        ),
                        if (isErasing && _eraserPosition != null)
                          Positioned(
                            top: _eraserPosition!.dy,
                            left: _eraserPosition!.dx,
                            child: Container(
                              width: 30,
                              height: 30,
                              // white circle with black outline
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onError,
                                shape: BoxShape.circle,
                                // shadow
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.onError.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            isDrawingMode
                ? Positioned.fill(
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() => isDrawing = true);
                        _beforeChange();
                        setState(() {
                          RenderBox renderBox = context.findRenderObject() as RenderBox;
                          Offset touchPoint = renderBox.globalToLocal(details.globalPosition);
                          List<Line> points = [];
                          double radius = 0.25; // or adjust as needed

                          for (double angle = 0; angle <= 360; angle += 45) {
                            double x = touchPoint.dx + radius * cos(angle * pi / 180);
                            double y = touchPoint.dy + radius * sin(angle * pi / 180);
                            points.add(Line(Offset(x, y), paintBrushBig, paintBrushColorSet));
                          }
                          lines.add(points);
                        });
                      },
                      onPanEnd: (details) {
                        setState(() => isDrawing = false);
                        if (lines.last.isEmpty) {
                          lines.removeLast();
                        }
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject() as RenderBox;
                          lines.last.add(
                              Line(renderBox.globalToLocal(details.globalPosition), paintBrushBig, paintBrushColorSet));
                        });
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            Positioned.fill(
              right: 10,
              left: 10,
              top: 20,
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CircleIconBtn(
                            isBig: true,
                            onTap: () {
                              router.pop();
                            },
                            icon: CupertinoIcons.xmark),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            buildTextSettingsMenu(context),
                            CircleIconBtn(
                              isSelected: _getCurrentEntry() != null,
                              isBig: true,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _beforeChange();
                                setState(() {
                                  if (isDrawingMode) {
                                    isDrawingMode = false;
                                  }
                                  if (isErasing) {
                                    isErasing = false;
                                  }
                                  _textEntries.add(TextEntry(""));
                                });
                              },
                              icon: Icons.text_fields,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            buildDrawingSettingsMenu(context),
                            CircleIconBtn(
                              isBig: true,
                              isSelected: isDrawingMode,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  if (_currentFocusedField != null) {
                                    return;
                                  }
                                  isDrawingMode = !isDrawingMode;
                                  if (isDrawingMode) {
                                    _currentFocusedField?.unfocus();
                                    if (isErasing) {
                                      isErasing = false;
                                    }
                                  }
                                });
                              },
                              icon: Icons.brush,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CircleIconBtn(
                          isSelected: isErasing,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              if (_currentFocusedField != null) {
                                _currentFocusedField?.unfocus();
                              }
                              if (isDrawingMode) {
                                isDrawingMode = false;
                              }
                              isErasing = !isErasing;
                            });
                          },
                          icon: CupertinoIcons.clear_thick_circled,
                          isBig: true,
                        ),
                        const SizedBox(height: 8),
                        CircleIconBtn(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            // unselects every other text, eraser, and draw
                            setState(() {
                              if (_currentFocusedField != null) {
                                _currentFocusedField?.unfocus();
                              }
                              if (isDrawingMode) {
                                isDrawingMode = false;
                              }
                              if (isErasing) {
                                isErasing = false;
                              }
                            });
                            // crops file using image_cropper pkg
                            ImageCropper()
                                .cropImage(
                              sourcePath: editingFile.path,
                              androidUiSettings: const AndroidUiSettings(
                                toolbarTitle: 'Crop Image',
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false,
                              ),
                              iosUiSettings: const IOSUiSettings(
                                title: 'Crop Image',
                              ),
                              compressQuality: 100,
                              compressFormat: ImageCompressFormat.png,
                              cropStyle: CropStyle.rectangle,
                            )
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  editingFile = value;
                                });
                              }
                            });
                          },
                          icon: Icons.crop,
                          isBig: true,
                        ),
                        const SizedBox(height: 8),
                        CircleIconBtn(
                          disabled: _undoStack.isEmpty,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            undo();
                          },
                          icon: Icons.undo,
                          isBig: true,
                        ),
                        const SizedBox(height: 8),
                        CircleIconBtn(
                          disabled: _redoStack.isEmpty,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            redo();
                          },
                          icon: Icons.redo,
                          isBig: true,
                        ),
                        const SizedBox(height: 8),
                        CircleIconBtn(
                          onTap: () async => (await _captureAndSaveImage(context).then((possibleSuccess) =>
                              possibleSuccess
                                  ? context.read<NotificationsCubit>().showSuccess("Image saved to gallery")
                                  : context.read<NotificationsCubit>().showErr("Error saving image"))),
                          icon: Icons.download,
                          isBig: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              bottom: heightFraction(context, 1 / 16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CircleIconBtn(
                  hasBorder: false,
                  isBig: thereIsSomeEntryInDeletionBoundary(),
                  bgColor: Theme.of(context).colorScheme.error,
                  icon: CupertinoIcons.trash,
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Line>> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeCap = StrokeCap.round;

    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        // Set the strokeWidth based on the isBig property
        paint.strokeWidth = line[i].isBig ? 15 : 5;
        paint.color = getColorsForSet(line[i].colorSet).item1;
        canvas.drawLine(line[i].offset, line[i + 1].offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class NeverUserScrollablePhysics extends ScrollPhysics {
  const NeverUserScrollablePhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  NeverUserScrollablePhysics applyTo(ScrollPhysics? ancestor) {
    return NeverUserScrollablePhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return false;
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return 0.0;
  }
}
