import 'package:flutter/material.dart';

import '../../shared/behaviours/init_scale.dart';
import '../../shared/text/header_group.dart';

class ShowcaseItem extends StatefulWidget {
  const ShowcaseItem(
      {required this.imgPath, required this.header, required this.body, required this.pageIndex, Key? key})
      : super(key: key);

  final int pageIndex;
  final String header;
  final String body;
  final String imgPath;

  @override
  State<ShowcaseItem> createState() => _ShowcaseItemState();
}

class _ShowcaseItemState extends State<ShowcaseItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: InitScale(
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      widget.imgPath,
                      width: width > 400 ? 400 : width * 4 / 5,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: HeaderGroupText(
                      multiLine: true,
                      body: widget.body,
                      header: widget.header,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
