import 'package:Confessi/application/shared/scaffold_shrinker_cubit.dart';
import 'package:Confessi/core/curves/bounce_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShrinkingView extends StatefulWidget {
  const ShrinkingView({
    required this.child,
    this.safeAreaBottom = true,
    this.topLeftSquare = false,
    this.topRightSquare = false,
    super.key,
  });

  final Widget child;
  final bool safeAreaBottom;
  final bool topLeftSquare;
  final bool topRightSquare;

  @override
  State<ShrinkingView> createState() => _ShrinkingViewState();
}

class _ShrinkingViewState extends State<ShrinkingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
      reverseCurve: Curves.linear,
    );
    super.initState();
  }

  void startAnim() async {
    _animController.forward();
    _animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    _animController.reverse();
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScaffoldShrinkerCubit, ScaffoldShrinkerState>(
      listener: (context, state) {
        if (state is Shrunk) {
          startAnim();
        } else if (state is Enlarged) {
          reverseAnim();
        }
      },
      child: Container(
        color: Colors.black, // Theme.of(context).colorScheme.shadow
        child: Transform.scale(
          scale: -_anim.value * .00 + 1,
          child: Transform.translate(
            offset: Offset(
                0, _anim.value * MediaQuery.of(context).size.height * .055),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        widget.topLeftSquare ? 0 : _anim.value * 50),
                    topRight: Radius.circular(
                        widget.topRightSquare ? 0 : _anim.value * 50)),
                color: Theme.of(context).colorScheme.background,
              ),
              child: SafeArea(
                maintainBottomViewPadding: true,
                bottom: widget.safeAreaBottom,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(_anim.value * 50),
                      bottomRight: Radius.circular(_anim.value * 50)),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
