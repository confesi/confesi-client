import 'package:flutter/material.dart';

import '../../../../core/widgets/text/header_group.dart';

class ShowcaseItem extends StatelessWidget {
  const ShowcaseItem(
      {required this.imgPath,
      required this.header,
      required this.body,
      required this.pageIndex,
      Key? key})
      : super(key: key);

  final int pageIndex;
  final String header;
  final String body;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      imgPath,
                      width: width > 400 ? 400 : width * 4 / 5,
                      fit: BoxFit.fitWidth,
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
                        body: body,
                        header: header,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
