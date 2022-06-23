import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class InfiniteScrollable extends StatefulWidget {
  const InfiniteScrollable({Key? key}) : super(key: key);

  @override
  State<InfiniteScrollable> createState() => _InfiniteScrollableState();
}

class _InfiniteScrollableState extends State<InfiniteScrollable> {
  @override
  void initState() {
    getPosts();
    itemPositionsListener.itemPositions.addListener(() {
      final indicies = itemPositionsListener.itemPositions.value.map((post) => post.index);
      // print(
      //     "indicies: $indicies, detail: ${indicies.toList().last}, posts length: ${posts.length}");
      // can add check if the list is at least x long, then check back to reload preemtively by x items
      if (currentlyFetching == false &&
          noMorePosts == false &&
          hasError == false &&
          indicies.toList().last == posts.length) {
        getPosts();
      }
    });
    super.initState();
  }

  Future<void> getPosts() async {
    currentlyFetching = true;
    print("<===========>");
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
    await Future.delayed(const Duration(seconds: 1));
    if (response.statusCode == 200) {
      for (int i = 0; i < 5; i++) {
        if (i == 4) {
          posts.add("END END END END END");
        } else {
          posts.add(json.decode(response.body)[Random().nextInt(100)]["title"]);
        }
      }
    }
    setState(() {});
    currentlyFetching = false;
  }

  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();

  Widget infiniteList() {
    return ScrollablePositionedList.builder(
      physics: const BouncingScrollPhysics(),
      itemPositionsListener: itemPositionsListener,
      itemScrollController: itemScrollController,
      itemCount: posts.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index < posts.length
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  width: double.infinity,
                  color: Colors.blueAccent.withOpacity(.2),
                  child: TextButton(
                    onPressed: () => getPosts(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Text("${index + 1} + ${posts[index]}"),
                    ),
                  ),
                ),
              )
            : hasError
                ? TextButton(
                    onPressed: () => tryAgain(),
                    child: const Text("error loading more, try again"),
                  )
                : noMorePosts
                    ? TextButton(
                        onPressed: () => tryAgain(),
                        child: const Text("out of posts, try loading more"),
                      )
                    : const CupertinoActivityIndicator();
      },
    );
  }

  void tryAgain() {
    setState(() {
      noMorePosts = false;
      hasError = false;
    });
    getPosts();
  }

  Widget spinner() {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget error() {
    return const Center(child: Text("error"));
  }

  Widget empty() {
    return const Center(child: Text("no more posts"));
  }

  List posts = [];
  bool currentlyFetching = false;
  bool hasError = false; // false
  bool noMorePosts = false; // false

  Widget getBody() {
    if (posts.isEmpty) {
      // no posts
      if (hasError) {
        return error();
      } else if (noMorePosts) {
        return empty();
      } else {
        return spinner();
      }
    } else {
      // has posts
      return infiniteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      extentPercentageToArmed: 0.1,
      onRefresh: () async {
        HapticFeedback.lightImpact();
        await Future.delayed(const Duration(seconds: 1));
      },
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Padding(
              padding: EdgeInsets.only(top: !controller.isIdle ? 15.0 * controller.value : 0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  if (!controller.isIdle)
                    Transform.scale(
                      scale: controller.value >= 1 ? 1 : controller.value,
                      child: const CupertinoActivityIndicator(),
                    ),
                  Opacity(
                    opacity: controller.isArmed || controller.isLoading
                        ? controller.value > 1
                            ? 1
                            : controller.value
                        : 1,
                    child: Transform.translate(
                      offset: Offset(0, 25.0 * controller.value),
                      child: child,
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            FadeTransition(opacity: animation, child: child),
        child: getBody(),
      ),
    );
  }
}
