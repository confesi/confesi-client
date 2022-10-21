import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/animated_cliprrect.dart';
import 'package:flutter/material.dart';

class FadeMessageTextController extends ChangeNotifier {
  bool isShown = false;
  String message = "";
  bool isHiding = false;

  void show(String text) async {
    if (isShown || isHiding) await hide();
    if (isHiding) return;
    isShown = true;
    message = text;
    if (!isHiding) notifyListeners();
  }

  Future<void> hide() async {
    isHiding = true;
    isShown = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));
    isHiding = false;
  }
}

class FadeMessageText extends StatefulWidget {
  const FadeMessageText({
    super.key,
    required this.controller,
  });

  final FadeMessageTextController controller;

  @override
  State<FadeMessageText> createState() => _FadeMessageTextState();
}

class _FadeMessageTextState extends State<FadeMessageText> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    widget.controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedClipRect(
        alignment: Alignment.topLeft,
        open: widget.controller.isShown,
        duration: const Duration(milliseconds: 350),
        curve: Curves.decelerate,
        reverseCurve: Curves.decelerate,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            widget.controller.message,
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
