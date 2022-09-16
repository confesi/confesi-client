import 'package:flutter/material.dart';

class ShrinkingViewController extends ChangeNotifier {
  late AnimationController _animController;
  late Animation _anim;

  late VoidCallback _shrinkView;
  late VoidCallback _enlargeView;

  void setShrink(VoidCallback voidCallback) => _shrinkView = voidCallback;
  void setEnlarge(VoidCallback voidCallback) => _enlargeView = voidCallback;

  ShrinkingViewController(TickerProvider tickerProvider) {
    _animController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _anim = CurvedAnimation(
        parent: _animController,
        curve: Curves.linear,
        reverseCurve: Curves.linear);
  }

  void shrink() => _shrinkView();

  void enlarge() => _enlargeView();
}

class ShrinkingView extends StatefulWidget {
  const ShrinkingView({
    required this.child,
    required this.controller,
    super.key,
  });

  final Widget child;
  final ShrinkingViewController controller;

  @override
  State<ShrinkingView> createState() => _ShrinkingViewState();
}

class _ShrinkingViewState extends State<ShrinkingView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.controller.setShrink(() => startAnim());
    widget.controller.setEnlarge(() => reverseAnim());
    super.initState();
  }

  void startAnim() async {
    widget.controller._animController.forward();
    widget.controller._animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    widget.controller._animController.reverse();
    widget.controller._animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.controller._animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: -widget.controller._anim.value * .1 + 1,
        child: widget.child,
      ),
    );
  }
}
