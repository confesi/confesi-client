import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';

dynamic showTopChip(BuildContext context, String text) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          overlay?.remove();
        },
        child: Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: _OverlayItem(text: text, overlay: overlay),
            ),
          ),
        ),
      );
    },
  );
  Overlay.of(context)?.insert(overlay);
}

class _OverlayItem extends StatefulWidget {
  const _OverlayItem({
    Key? key,
    required this.text,
    required this.overlay,
  }) : super(key: key);

  final String text;
  final OverlayEntry? overlay;

  @override
  State<_OverlayItem> createState() => __OverlayItemState();
}

class __OverlayItemState extends State<_OverlayItem> with SingleTickerProviderStateMixin {
  late AnimationController translateAnimController;
  late Animation translateAnim;

  @override
  void initState() {
    translateAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
      reverseDuration: const Duration(milliseconds: 450),
    );
    translateAnim = CurvedAnimation(
      parent: translateAnimController,
      curve: Curves.decelerate,
      reverseCurve: Curves.decelerate,
    );
    startAnim();
    super.initState();
  }

  @override
  void dispose() {
    translateAnimController.dispose();
    super.dispose();
  }

  void startAnim() async {
    translateAnimController.forward().then((value) async {
      await Future.delayed(const Duration(milliseconds: 3000));
      if (mounted) {
        translateAnimController.reverse().then((_) {
          if (widget.overlay != null) widget.overlay!.remove();
        });
      }
    });
    translateAnimController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -(1 - translateAnim.value) * heightFraction(context, .25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Container(
          constraints: BoxConstraints(maxHeight: heightFraction(context, .2)),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.error.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.fitHeight,
                  child: ClipRRect(
                    child: Transform.translate(
                      offset: const Offset(-3, -3),
                      child: Icon(
                        CupertinoIcons.hammer,
                        color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: .9,
                        child: Text(
                          widget.text,
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      CupertinoIcons.xmark,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
