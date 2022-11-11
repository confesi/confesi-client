import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';

enum ScreenSide {
  top,
  bottom,
}

enum NotificationType {
  success,
  failure,
}

dynamic showNotificationChip(BuildContext context, String text,
    {ScreenSide screenSide = ScreenSide.bottom, NotificationType notificationType = NotificationType.failure}) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return IgnorePointer(
        ignoring: true,
        child: Align(
          alignment: screenSide == ScreenSide.top ? Alignment.topCenter : Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: _OverlayItem(
                  text: text, overlay: overlay, screenSide: screenSide, notificationType: notificationType),
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
    required this.screenSide,
    required this.notificationType,
  }) : super(key: key);

  final String text;
  final OverlayEntry? overlay;
  final ScreenSide screenSide;
  final NotificationType notificationType;

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
      duration: const Duration(milliseconds: 450),
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
      offset: Offset(0,
          (widget.screenSide == ScreenSide.bottom ? 1 : -1) * (1 - translateAnim.value) * heightFraction(context, .25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: heightFraction(context, .2)),
          decoration: BoxDecoration(
            color: widget.notificationType == NotificationType.failure
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.surfaceTint,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
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
                    ],
                  ),
                ),
                Container(
                  height: 5,
                  width: timeAnim.value * widthFraction(context, 1),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.onError.withOpacity(0.75)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
