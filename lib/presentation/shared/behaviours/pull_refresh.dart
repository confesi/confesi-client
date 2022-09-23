import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
import 'package:Confessi/presentation/shared/indicators/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PullRefresh extends StatefulWidget {
  const PullRefresh({
    super.key,
    required this.onTap,
    required this.child,
  });

  final Widget child;
  final Future<void> Function() onTap;
  @override
  State<PullRefresh> createState() => _PullRefreshState();
}

class _PullRefreshState extends State<PullRefresh>
    with TickerProviderStateMixin {
  double height = 0.0;
  bool isLoading = false;

  late AnimationController _animController;
  late Animation _anim;

  @override
  void initState() {
    _animController = AnimationController(
      value: 1,
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
      reverseCurve: Curves.linear,
    );
    super.initState();
  }

  void startAnim() async {
    _animController.forward();
    _animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    _animController.reverse();
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double animValue() => _anim.value;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (details) {
        if (details.metrics.pixels <= 0) {
          setState(() {
            height = -details.metrics.pixels;
          });
          if (height >= 150 && !isLoading) {
            isLoading = true;
            startAnim();
            widget.onTap().then((value) => isLoading = false);
            HapticFeedback.lightImpact();
          }
        }
        return false;
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          widget.child,
          Transform.scale(
            scale: 1,
            child: Transform.translate(
              offset: Offset(
                  0,
                  (-50 +
                      (isLoading
                          ? animValue() * 150
                          : numberUntilLimit(height, 150)))),
              child: Container(
                color: Colors.orangeAccent,
                height: 50,
                width: 50,
                child: const LoadingIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
