import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/buttons/single_text.dart';
import 'package:flutter_mobile_client/widgets/text/header_group.dart';

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
                flex: 3,
                child: Center(
                  child: Image.asset(
                    imgPath,
                    width: width > 250 ? 250 : width * 2 / 3,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: HeaderGroupText(
                      dark: true,
                      body: body,
                      header: header,
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
