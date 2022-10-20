import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';

dynamic showTopChip(BuildContext context, String text) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return IgnorePointer(
        ignoring: true,
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

class __OverlayItemState extends State<_OverlayItem> with TickerProviderStateMixin {
  late AnimationController translateAnimController;
  late Animation translateAnim;

  late AnimationController timeAnimController;
  late Animation timeAnim;

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
    timeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    timeAnim = CurvedAnimation(
      parent: timeAnimController,
      curve: Curves.linear,
    );
    startAnim();
    super.initState();
  }

  @override
  void dispose() {
    translateAnimController.dispose();
    timeAnimController.dispose();
    super.dispose();
  }

  void startAnim() async {
    timeAnimController.forward();
    translateAnimController.forward().then((value) async {
      await Future.delayed(const Duration(milliseconds: 2500));
      if (mounted) {
        translateAnimController.reverse().then((_) {
          if (widget.overlay != null) widget.overlay!.remove();
        });
      }
    });
    translateAnimController.addListener(() => setState(() {}));
    timeAnimController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -(1 - translateAnim.value) * heightFraction(context, .25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: heightFraction(context, .2)),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // Positioned.fill(
                //   child: ClipRRect(
                //     clipBehavior: Clip.hardEdge,
                //     child: FittedBox(
                //       alignment: Alignment.centerLeft,
                //       fit: BoxFit.contain,
                //       child: Transform.translate(
                //         offset: const Offset(-3, -3),
                //         child: Icon(
                //           CupertinoIcons.hammer,
                //           color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.15),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        widget.text,
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 5,
                      width: timeAnim.value * widthFraction(context, 1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onError.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
