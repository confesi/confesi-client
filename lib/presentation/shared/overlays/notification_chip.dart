import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';

import '../../../core/utils/sizing/width_fraction.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';

/// What type of notification is being displayed.
///
/// Typically, [failure] is red, and [success] is green.
enum NotificationType {
  success,
  failure,
}

/// How long a notification is displayed for.
///
/// [regular] is 2000 ms, [long] is 5500 ms.
enum NotificationDuration {
  regular,
  long,
}

dynamic showNotificationChip(
  BuildContext context,
  String text, {
  int maxLines = 3,
  NotificationType notificationType = NotificationType.failure,
  NotificationDuration notificationDuration = NotificationDuration.regular,
}) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: _OverlayItem(
            text: text,
            overlay: overlay,
            maxLines: maxLines,
            notificationChipType: notificationType,
            notificationDuration: notificationDuration,
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
    required this.notificationChipType,
    required this.maxLines,
    required this.notificationDuration,
  }) : super(key: key);

  final String text;
  final OverlayEntry? overlay;
  final NotificationType notificationChipType;
  final int maxLines;
  final NotificationDuration notificationDuration;

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
      duration: const Duration(milliseconds: 1500),
    );
    translateAnim = CurvedAnimation(
      parent: translateAnimController,
      curve: Curves.ease,
    );
    timeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 250),
    );
    timeAnim = CurvedAnimation(
      parent: timeAnimController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.decelerate,
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

  void reverseAnimEarly() {
    if (!mounted || widget.overlay == null) return;
    translateAnimController.forward().then((value) => widget.overlay!.remove());
    translateAnimController.addListener(() => setState(() {}));
  }

  void startAnim() {
    if (!mounted || widget.overlay == null) return;
    timeAnimController.forward().then((_) async {
      await Future.delayed(
          Duration(milliseconds: widget.notificationDuration == NotificationDuration.regular ? 2000 : 5500));
      if (!mounted || widget.overlay == null) return;
      timeAnimController.reverse().then((value) => widget.overlay!.remove());
    });
    timeAnimController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, translateAnim.value * -heightFraction(context, 1)),
      child: TouchableScale(
        onTap: () => reverseAnimEarly(),
        child: Transform.scale(
          scale: timeAnim.value,
          child: Container(
            constraints: BoxConstraints(maxWidth: widthFraction(context, .8)),
            decoration: BoxDecoration(
              color: widget.notificationChipType == NotificationType.failure
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.surfaceTint,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  widget.text,
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
                  maxLines: widget.maxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
