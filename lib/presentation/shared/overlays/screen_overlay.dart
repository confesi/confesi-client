import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/core/styles/themes.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/services/user_auth/user_auth_data.dart';
import '../button_touch_effects/touchable_scale.dart';

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
/// [regular] is 3500 ms, [long] is 6000 ms.
enum NotificationDuration {
  regular,
  long,
}

const int _verticalSlideInOffset = 75;

/// Show a full overlay entry.
///
/// Be sure to REMOVE IT once done with via ~ `overlay!.remove()`
dynamic showFullOverlay(BuildContext context, OverlayEntry overlay) {
  Overlay.of(context).insert(overlay);
}

dynamic showNotificationChip(
  BuildContext context,
  String text, {
  int maxLines = 4,
  NotificationType notificationType = NotificationType.failure,
  NotificationDuration notificationDuration = NotificationDuration.regular,
  VoidCallback? onTap,
}) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: _OverlayItem(
            onTap: onTap,
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
  Overlay.of(context).insert(overlay);
}

class _OverlayItem extends StatefulWidget {
  const _OverlayItem({
    Key? key,
    required this.text,
    required this.overlay,
    required this.notificationChipType,
    required this.maxLines,
    required this.notificationDuration,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
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
          Duration(milliseconds: widget.notificationDuration == NotificationDuration.regular ? 3500 : 6000));
      if (!mounted || widget.overlay == null) return;
      timeAnimController.reverse().then((value) => widget.overlay!.remove());
    });
    timeAnimController.addListener(() => setState(() {}));
  }

  double totalSwipe = 0.0;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserAuthService>(context, listen: true).data();
    final ThemeData theme = data.themePref == ThemePref.system
        ? AppTheme.dark
        : data.themePref == ThemePref.light
            ? AppTheme.light
            : AppTheme.dark;
    return Transform.translate(
      offset: Offset(0, translateAnim.value * -heightFraction(context, 1) + (totalSwipe <= 0 ? totalSwipe : 0)),
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (totalSwipe < 0) {
            reverseAnimEarly();
          }
        },
        onVerticalDragCancel: () {
          if (totalSwipe <= 0) {
            reverseAnimEarly();
          }
        },
        onVerticalDragUpdate: (details) {
          if (translateAnim.value != 0) return;
          if (details.delta.dy <= 0 || totalSwipe < 0) {
            setState(() {
              totalSwipe += details.delta.dy;
            });
          }
        },
        child: Transform.translate(
          offset: Offset(0, ((timeAnim.value * _verticalSlideInOffset) - _verticalSlideInOffset).toDouble()),
          child: TouchableScale(
            onTap: () {
              HapticFeedback.lightImpact();
              reverseAnimEarly();
              if (widget.onTap != null) widget.onTap!();
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                constraints: BoxConstraints(maxWidth: widthFraction(context, .95)),
                decoration: BoxDecoration(
                  color: widget.notificationChipType == NotificationType.failure
                      ? theme.colorScheme.error
                      : theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  // border: Border.all(
                  //   color: theme.colorScheme.onBackground,
                  //   width: borderSize,
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    widget.text,
                    style: kTitle.copyWith(
                      color: theme.colorScheme.onError,
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
      ),
    );
  }
}
