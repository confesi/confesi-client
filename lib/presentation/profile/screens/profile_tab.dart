import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';

// TODO: add automatickeepalive mixin to tabs?

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) => true,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.background,
              height: 500,
            ),
            Container(
              color: Colors.blue,
              height: 500,
            ),
            Container(
              color: Colors.green,
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
