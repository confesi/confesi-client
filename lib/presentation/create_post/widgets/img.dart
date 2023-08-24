import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrollable/exports.dart';
import 'package:tuple/tuple.dart';

import '../../shared/edited_source_widgets/matrix_gesture_detector.dart';

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
      this.isBold = false,
      this.colorSet = ColorSet.white,
      this.offset = Offset.zero})
      : matrix = Matrix4.identity();
}

class ImageEditorScreen extends StatefulWidget {
  final File file;

  const ImageEditorScreen({Key? key, required this.file}) : super(key: key);

  @override
  ImageEditorScreenState createState() => ImageEditorScreenState();
}

class ImageEditorScreenState extends State<ImageEditorScreen> {
  List<TextEntry> _textEntries = [];
  Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>> _textControllers = {};

  FocusNode? _currentFocusedField;
  bool get _showFontSizeSlider => _currentFocusedField != null;
  FocusAttachment? _focusAttachment;
  HashSet<TextEntry> currentDraggingEntries = HashSet();
  List<
      Tuple3<List<TextEntry>, Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>>,
          List<List<Offset>>>> _undoStack = [];
  List<
      Tuple3<List<TextEntry>, Map<TextEntry, Tuple4<TextEditingController, FocusNode, double, Offset>>,
          List<List<Offset>>>> _redoStack = [];

  bool isDrawingMode = false;
  List<List<Offset>> lines = [];

  void _beforeChange() {
    print("BEFORE CHANGE");
    _undoStack.add(Tuple3(_textEntries.map((e) => e.clone()).toList(), _deepCopyTextControllers(_textControllers),
        lines.isNotEmpty ? lines.map<List<Offset>>((line) => List<Offset>.from(line)).toList() : []));
    _redoStack.clear();
  }

  void _refreshState() {
    // Here you can refresh the state of your widget or perform any action that is required
    // For example, you can update some variables and then call `setState` to rebuild the widget
    setState(() {
      // Update any state variables here
    });
  }

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
      lines = lastState.item3.map<List<Offset>>((line) => List<Offset>.from(line)).toList();

      _refreshState();
    }
  }

  void _restoreStateFromRedoStack() {
    if (_redoStack.isNotEmpty) {
      final nextState = _redoStack.removeLast();
      _textEntries = nextState.item1;
      _textControllers = _deepCopyTextControllers(nextState.item2);
      lines = nextState.item3.map<List<Offset>>((line) => List<Offset>.from(line)).toList();

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
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: hasBg ? colors.item1 : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: IgnorePointer(
                ignoring: !focusNode.hasFocus,
                child: TextField(
                  // onChanged: (value) => _beforeChange(),
                  cursorColor: colors.item2,
                  scrollPadding: EdgeInsets.zero,
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

  bool hasDoneHapticForDeleteAlready = false;

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

  Widget _buildEditableTransformedText(TextEntry entry) {
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
          print("drag start");
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
              max: 40.0,
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

  Widget buildSettingsMenu(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CheckeredBackground(
              color1: Theme.of(context).colorScheme.tertiary, color2: Theme.of(context).colorScheme.tertiary),
          Positioned.fill(
            child: KeyboardDismiss(
              child: Image.file(widget.file, fit: BoxFit.contain),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: DrawingPainter(lines)),
          ),
          ..._textEntries.map((entry) => _buildEditableTransformedText(entry)).toList(),
          Positioned(top: MediaQuery.of(context).size.height / 2 - 150, child: buildSlider(context)),
          isDrawingMode
              ? Positioned.fill(
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (isDrawingMode) {
                        _beforeChange();
                        setState(() {
                          RenderBox renderBox = context.findRenderObject() as RenderBox;
                          Offset touchPoint = renderBox.globalToLocal(details.globalPosition);

                          List<Offset> points = [];
                          double radius = 0.5; // or adjust as needed

                          // Add several points around the touch point to simulate a small circle
                          for (double angle = 0; angle <= 360; angle += 45) {
                            double x = touchPoint.dx + radius * cos(angle * pi / 180);
                            double y = touchPoint.dy + radius * sin(angle * pi / 180);
                            points.add(Offset(x, y));
                          }

                          lines.add(points);
                        });
                      }
                    },
                    onPanEnd: (details) {
                      if (isDrawingMode) {
                        if (lines.last.isEmpty) {
                          lines.removeLast();
                        }
                      }
                    },
                    onPanUpdate: (details) {
                      if (isDrawingMode) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject() as RenderBox;
                          lines.last
                              .add(renderBox.globalToLocal(details.globalPosition)); // Add points to the current line
                        });
                      }
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
                          buildSettingsMenu(context),
                          CircleIconBtn(
                              isBig: true,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _beforeChange();
                                setState(() {
                                  _textEntries.add(TextEntry(""));
                                });
                              },
                              icon: Icons.text_fields),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CircleIconBtn(
                        isBig: true,
                        isSelected: isDrawingMode,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            isDrawingMode = !isDrawingMode;
                            if (isDrawingMode) {
                              // Disable text interaction when drawing is enabled
                              _currentFocusedField?.unfocus();
                            }
                          });
                        },
                        icon: Icons.brush,
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
                        onTap: () => print("tap"),
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
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (final line in lines) {
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
