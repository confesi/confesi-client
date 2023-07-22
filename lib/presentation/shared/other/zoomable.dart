import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Zoomable extends StatefulWidget {
  const Zoomable({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<Zoomable> createState() => _ZoomableState();
}

class _ZoomableState extends State<Zoomable> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  final TransformationController controller = TransformationController();

  final _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _animation = TweenSequence([
      TweenSequenceItem<Matrix4>(
        tween: Matrix4Tween(begin: controller.value, end: Matrix4.identity()),
        weight: 1.0,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        if (_animationController.value == 0) {
          HapticFeedback.lightImpact();
        }
        controller.value = _animation.value;
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _zoomOut() {
    if (controller.value == Matrix4.identity()) return;
    final Matrix4 currentTransform = controller.value;
    final Matrix4 targetTransform = Matrix4.identity();
    _animationController.reset();
    _animationController.duration = const Duration(milliseconds: 250);
    _animation = Matrix4Tween(
      begin: currentTransform,
      end: targetTransform,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  void _zoomIn(TapDownDetails details) {
    final RenderBox? box = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset localPosition = box.globalToLocal(details.globalPosition);
    const double targetScale = 2.5;
    final Offset targetOffset = Offset(-localPosition.dx, -localPosition.dy) * (targetScale - 1.0);

    Matrix4 currentMatrix = controller.value;
    Matrix4 targetMatrix = Matrix4.identity()
      ..translate(targetOffset.dx, targetOffset.dy)
      ..scale(targetScale);

    _animationController.reset();

    _animation = Matrix4Tween(
      begin: currentMatrix,
      end: targetMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  /// Checks if the matrix is "zoomed out" for an `InteractiveViewer` widget.
  ///
  /// We must do this check because the `InteractiveViewer` when manually zoomed out
  /// by gesture doesn't perfectly render an identity matrix; it's off by some small value.
  bool isMatrixZoomedOut(Matrix4 matrix) {
    const double eps = 1e-5;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        double val = matrix.getColumn(i)[j];
        if (val.abs() > eps.abs() && val.abs() != 1.0 && val.abs() != 0) {
          return false;
        }
      }
    }
    return true;
  }

  void _zoomDelegator(TapDownDetails details) {
    if (isMatrixZoomedOut(controller.value)) {
      _zoomIn(details);
    } else {
      _zoomOut();
    }
  }

  TransformationController transformController = TransformationController();
  final double _maxScale = 2.5;

  TapDownDetails? _tapDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (TapDownDetails details) => _zoomDelegator(details),
      onTapDown: (details) => _tapDetails = details,
      onLongPress: () => _zoomIn(_tapDetails!),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
        ),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.8,
          maxScale: _maxScale + 1.5,
          // boundaryMargin: const EdgeInsets.all(20),
          key: _imageKey,
          transformationController: controller,
          child: widget.child,
        ),
      ),
    );
  }
}
