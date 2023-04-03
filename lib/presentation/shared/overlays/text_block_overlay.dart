import 'package:Confessi/core/utils/dates/date_from_datetime.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/buttons/pop.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/dates/human_date_from_datetime.dart';
import '../../../core/utils/sizing/height_fraction.dart';

class UpdateMessage {
  const UpdateMessage({required this.title, required this.body, required this.id, required this.date});

  final String title;
  final String body;
  final int id;
  final DateTime date;
}

dynamic showTextBlock(BuildContext context, List<UpdateMessage> messages) {
  OverlayEntry? overlay;
  overlay = OverlayEntry(
    builder: (context) {
      return Align(
        alignment: Alignment.topCenter,
        child: _OverlayItem(
          messages: messages,
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
    required this.messages,
    required this.overlay,
  }) : super(key: key);

  final List<UpdateMessage> messages;
  final OverlayEntry? overlay;

  @override
  State<_OverlayItem> createState() => __OverlayItemState();
}

class __OverlayItemState extends State<_OverlayItem> with TickerProviderStateMixin {
  late AnimationController timeAnimController;
  late Animation timeAnim;

  late TabController _tabController;

  int _currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: widget.messages.length, vsync: this);
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
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
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

  int messagesLeft() => widget.messages.length - (_currentIndex + 1);

  void animateToNext() {
    // todo: remove current thing from messages local db
    if (_currentIndex == widget.messages.length - 1) {
      reverseAnim();
    } else {
      _tabController.animateTo(_currentIndex + 1);
    }
  }

  void skipAll() {
    // todo: remove all things from messages local db
    reverseAnim();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Transform.scale(
            scale: timeAnim.value,
            child: Container(
              height: heightFraction(context, 1),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.background.withOpacity(.5),
                    blurRadius: 25,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Material(
                  color: Colors.transparent,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Use a TabView to iterate through all the UpdateMessages
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: widget.messages.map((message) {
                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.title,
                                      style: kDisplay2.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      humanDateFromDatetime(message.date),
                                      style: kBody.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      message.body,
                                      style: kBody.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: PopButton(
                                onPress: () => skipAll(),
                                icon: CupertinoIcons.arrow_right,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.onSecondary,
                                justText: true,
                                text: "Skip all",
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: PopButton(
                                onPress: () => animateToNext(),
                                icon: CupertinoIcons.arrow_right,
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.onSecondary,
                                justText: true,
                                text: messagesLeft() == 0 ? "Close" : "Next (${messagesLeft()})",
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
      ],
    );
  }
}
