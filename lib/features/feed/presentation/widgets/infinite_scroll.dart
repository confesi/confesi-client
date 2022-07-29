import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfiniteScroll extends StatefulWidget {
  const InfiniteScroll({
    required this.itemCount,
    required this.onRefresh,
    required this.onReachedBottom,
    Key? key,
  }) : super(key: key);

  final int itemCount;
  final Function onRefresh;
  final Function onReachedBottom;

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  bool isRefreshing = false;
  late ScrollController scrollController;
  late ScrollController scrollbarController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        print("BOOP");
      }
    });
    scrollbarController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: scrollController,
      child: CustomRefreshIndicator(
        extentPercentageToArmed: 0.15,
        onRefresh: () async {
          HapticFeedback.lightImpact();
          setState(() {
            isRefreshing = true;
          });
          await widget.onRefresh();
          setState(() {
            isRefreshing = false;
          });
        },
        builder: (BuildContext context, Widget child, IndicatorController controller) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              return Stack(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, _) {
                      return Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        width: double.infinity,
                        height: controller.value * 80,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CupertinoActivityIndicator(
                              radius: 15,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Transform.translate(
                    offset: Offset(0, controller.value * 80),
                    child: child,
                  ),
                ],
              );
            },
          );
        },
        child: AbsorbPointer(
          absorbing: isRefreshing,
          child: PrimaryScrollController(
            controller: scrollController,
            child: ListView.builder(
              primary: true,
              itemCount: widget.itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    height: 100,
                    color: Colors.pink,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
