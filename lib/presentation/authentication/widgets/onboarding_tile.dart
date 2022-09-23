import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:flutter/material.dart';

import '../../shared/text/header_group.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: InitTransform(
                magnitudeOfTransform: -heightFraction(context, 1),
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
            ),
            Expanded(
              flex: 2,
              child: InitScale(
                child: Container(
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: HeaderGroupText(
                        multiLine: true,
                        body: body,
                        header: header,
                      ),
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
