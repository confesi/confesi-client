import 'package:Confessi/core/utils/styles/appearance_type.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputHighlight extends StatefulWidget {
  const TextInputHighlight({super.key});

  @override
  State<TextInputHighlight> createState() => _TextInputHighlightState();
}

class _TextInputHighlightState extends State<TextInputHighlight> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.linear,
    );
    _animController.addListener(() {
      if (_anim.isCompleted) _animController.reverse();
      if (_anim.isDismissed) _animController.forward();
      setState(() {});
    });
    startAnimation();
    super.initState();
  }

  void startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        print("tap");
      },
      child: Container(
        // Transparent hitbox trick.
        color: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 2, left: 3, right: 3),
        width: 75,
        height: 25,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: (.3 + _anim.value * .7),
            child: Container(
              width: 70,
              height: 2,
              decoration: BoxDecoration(
                color: appearanceType(context) == Brightness.dark
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
