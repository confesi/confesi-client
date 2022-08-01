import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/post.dart';

class InfiniteScroll extends StatefulWidget {
  const InfiniteScroll({
    required this.onLoad,
    required this.items,
    Key? key,
  }) : super(key: key);

  final Function onLoad;
  final List<Post> items;

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  bool isRefreshing = false;
  late ScrollController scrollController;
  bool calling = false;
  int loads = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        setState(() {
          loads++;
        });
        await widget.onLoad();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchMore());
    super.initState();
  }

  Future<void> _fetchMore() async {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      await widget.onLoad();
      // Adding this line prevents a stack overflow error.
      await Future.delayed(Duration.zero);
      _fetchMore();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: scrollController,
      child: CustomRefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          setState(() {
            isRefreshing = true;
          });
          await widget.onLoad();
          await Future.delayed(const Duration(milliseconds: 800));
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
                              radius: 12,
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
                  Text(
                    "loads: $loads",
                    style: const TextStyle(fontSize: 35),
                  ),
                ],
              );
            },
          );
        },
        child: AbsorbPointer(
          absorbing: isRefreshing,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            itemCount: widget.items.length + 1,
            itemBuilder: (context, index) {
              if (index < widget.items.length) {
                return Padding(
                  padding: index == 0 ? const EdgeInsets.all(0) : const EdgeInsets.only(top: 16),
                  child: Container(
                    height: 200,
                    color: Colors.pink,
                    child: Center(
                      child: Text("data: ${widget.items[index].faculty}"),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 100,
                  color: Colors.blueAccent.withOpacity(0.2),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
