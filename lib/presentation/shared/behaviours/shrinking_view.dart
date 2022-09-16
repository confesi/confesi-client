import 'package:Confessi/core/cubit/scaffold_shrinker_cubit.dart';
import 'package:Confessi/core/curves/bounce_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShrinkingView extends StatefulWidget {
  const ShrinkingView({
    required this.child,
    super.key,
  });

  final Widget child;

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
      duration: const Duration(milliseconds: 350),
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
      child: Center(
        child: Transform.scale(
          scale: -_anim.value * .085 + 1,
          child: widget.child,
        ),
      ),
    );
  }
}
