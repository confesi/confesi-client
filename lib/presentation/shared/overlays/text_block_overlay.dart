import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/buttons/pop.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/utils/sizing/width_fraction.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';

dynamic showTextBlock(BuildContext context, String title, String body) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return Align(
        alignment: Alignment.topCenter,
        child: _OverlayItem(
          title: title,
          body: body,
          overlay: overlay,
        ),
      );
    },
  );
  Overlay.of(context).insert(overlay);
}

class _OverlayItem extends StatefulWidget {
  const _OverlayItem({
    Key? key,
    required this.title,
    required this.body,
    required this.overlay,
  }) : super(key: key);

  final String title;
  final String body;
  final OverlayEntry? overlay;

  @override
  State<_OverlayItem> createState() => __OverlayItemState();
}

class __OverlayItemState extends State<_OverlayItem> with TickerProviderStateMixin {
  late AnimationController timeAnimController;
  late Animation timeAnim;

  @override
  void initState() {
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
    timeAnimController.dispose();
    super.dispose();
  }

  void startAnim() {
    if (!mounted || widget.overlay == null) return;
    timeAnimController.forward();
    timeAnimController.addListener(() => setState(() {}));
  }

  void reverseAnim() {
    if (!mounted || widget.overlay == null) return;
    timeAnimController.reverse().then((value) {
      if (mounted && widget.overlay != null) {
        widget.overlay!.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      // Is transparent to block touch events
      color: Colors.transparent,
      child: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Transform.scale(
                scale: timeAnim.value,
                child: TouchableOpacity(
                  onTap: () => reverseAnim(),
                  child: Container(
                    height: heightFraction(context, 1),
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: widthFraction(context, .9)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.5),
                          blurRadius: 25,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: kDisplay2.copyWith(
                                        color: Theme.of(context).colorScheme.onSecondary,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      widget.body,
                                      style: kBody.copyWith(
                                        color: Theme.of(context).colorScheme.onSecondary,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: PopButton(
                                    onPress: () => print("tap"),
                                    icon: CupertinoIcons.arrow_right,
                                    backgroundColor: Theme.of(context).colorScheme.background,
                                    textColor: Theme.of(context).colorScheme.primary,
                                    justText: true,
                                    text: "Skip",
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: PopButton(
                                    onPress: () => print("tap"),
                                    icon: CupertinoIcons.arrow_right,
                                    backgroundColor: Theme.of(context).colorScheme.background,
                                    textColor: Theme.of(context).colorScheme.primary,
                                    justText: true,
                                    text: "Next (24)",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
