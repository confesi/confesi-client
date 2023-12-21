import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';

import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/creating_and_editing_posts_service/create_edit_posts_service.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/core/utils/sizing/height_fraction.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/presentation/feed/widgets/img_viewer.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:confesi/presentation/shared/buttons/circle_icon_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrollable/exports.dart';

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
    final notificationsCubit = context.read<NotificationsCubit>();
    final editingPostsService = context.read<CreatingEditingPostsService>();

    // // Check for permissions
    // final galleryPermission = await Permission.photos.request();
    // if (!galleryPermission.isGranted) {
    //   notificationsCubit.showErr("Permission denied");
    //   return;
    // }

    if (editingPostsService.images.map((e) => e.editingFile).toList().length >= widget.maxImages) {
      notificationsCubit.showErr("Max images reached");
      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null && editingPostsService.images.map((e) => e.editingFile).toList().length < widget.maxImages) {
      editingPostsService.images.add(EditorState.empty(File(pickedFile.path)));
      setState(() {
        widget.controller!.notify();
      });
      await Future.delayed(const Duration(milliseconds: 250));
      _animateToEndOfScrollview();
    }
  }

  Future<void> _selectFromCamera() async {
    final notificationsCubit = context.read<NotificationsCubit>();
    final editingPostsService = context.read<CreatingEditingPostsService>();

    // // Check for permissions
    // final cameraPermission = await Permission.camera.request();
    // if (!cameraPermission.isGranted) {
    //   notificationsCubit.showErr("Permission denied");
    //   return;
    // }

    if (editingPostsService.images.map((e) => e.editingFile).toList().length >= widget.maxImages) {
      notificationsCubit.showErr("Max images reached");
      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null && editingPostsService.images.map((e) => e.editingFile).toList().length < widget.maxImages) {
      editingPostsService.addImage(EditorState.empty(File(pickedFile.path)));
      setState(() {
        widget.controller!.notify();
      });
      await Future.delayed(const Duration(milliseconds: 250));
      _animateToEndOfScrollview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
            top: Provider.of<CreatingEditingPostsService>(context, listen: true)
                    .images
                    .map((e) => e.editingFile)
                    .toList()
                    .isEmpty
                ? 0
                : 15),
        height: widget.controller != null &&
                Provider.of<CreatingEditingPostsService>(context, listen: true)
                    .images
                    .map((e) => e.editingFile)
                    .toList()
                    .isNotEmpty
            ? 100
            : 0,
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
                  onReorderStart: (_) {
                    HapticFeedback.lightImpact();
                  },
                  scrollDirection: Axis.horizontal,
                  onReorder: (int oldIndex, int newIndex) {
                    HapticFeedback.lightImpact();
                    _onReorder(oldIndex, newIndex);
                  },
                  children: <Widget>[
                    for (int index = 0;
                        index <
                            Provider.of<CreatingEditingPostsService>(context, listen: true)
                                .images
                                .map((e) => e.editingFile)
                                .toList()
                                .length;
                        index++)
                      TouchableScale(
                        key: ValueKey(index),
                        onTap: () {
                          router.push(
                            "/img",
                            extra: ImgProps(
                                MyImageSource(
                                  file: File(Provider.of<CreatingEditingPostsService>(context, listen: false)
                                      .images
                                      .map((e) => e.editingFile)
                                      .toList()[index]
                                      .path),
                                ),
                                false,
                                "img$index"),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: _buildFilePreview(
                              Provider.of<CreatingEditingPostsService>(context, listen: true)
                                  .images
                                  .map((e) => e.editingFile)
                                  .toList()[index],
                              index),
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
                    '${Provider.of<CreatingEditingPostsService>(context, listen: true).images.map((e) => e.editingFile).toList().length}/${widget.maxImages} images',
                    style: kDetail.copyWith(
                      color: Provider.of<CreatingEditingPostsService>(context, listen: true)
                                  .images
                                  .map((e) => e.editingFile)
                                  .toList()
                                  .length ==
                              widget.maxImages
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

    final service = Provider.of<CreatingEditingPostsService>(context, listen: false);
    final List<EditorState> imagesList = List.from(service.images); // Deep copy of the original list.

    final item = imagesList.removeAt(oldIndex);
    imagesList.insert(newIndex, item);

    service.updateImages(imagesList);

    setState(() {
      widget.controller!.notify();
    });
  }

  void _scrollToEnd() {
    if (Provider.of<CreatingEditingPostsService>(context, listen: false)
        .images
        .map((e) => e.editingFile)
        .toList()
        .isNotEmpty) {
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
                  width: borderSize,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Hero(
                    tag: "img$index",
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
                Provider.of<CreatingEditingPostsService>(context, listen: false).images.removeWhere((element) {
                  return element.editingFile == file;
                });

                widget.controller!.notify();
              });
            },
          ),
        ),
      ],
    );
  }
}
