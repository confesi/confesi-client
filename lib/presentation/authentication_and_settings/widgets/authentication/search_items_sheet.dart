import '../../../../core/utils/sizing/bottom_safe_area.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/utils/sizing/height_fraction.dart';
import 'item_row_tile.dart';
import '../../../shared/layout/line.dart';
import '../../../shared/textfields/bulge_textfield.dart';
import 'package:flutter/material.dart';

import '../../../shared/layout/swipebar.dart';

Future<dynamic> showSearchItemsSheet(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      // Optionally, you can change this BorderRadius... it's kinda preference.
      builder: (context) => const _SheetBody());
}

class _SheetBody extends StatefulWidget {
  const _SheetBody();

  @override
  State<_SheetBody> createState() => __SheetBodyState();
}

class __SheetBodyState extends State<_SheetBody> {
  late TextEditingController textEditingController;
  bool textFieldFocused = false;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        duration: const Duration(milliseconds: 450),
        height: heightFraction(context, textFieldFocused ? 1 : .75),
        color: Theme.of(context).colorScheme.background,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 450),
          curve: Curves.linearToEaseOut,
          padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: textFieldFocused ? MediaQueryData.fromView(WidgetsBinding.instance.window).padding.top : 0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.linearToEaseOut,
                      child: textFieldFocused
                          ? Container()
                          : const Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: SwipebarLayout(),
                            ),
                    ),
                    BulgeTextField(
                      rightButtonOnTap: () => Navigator.pop(context),
                      rightButtonText: "Close",
                      hasRightButton: textFieldFocused,
                      onFocusChange: (focusStatus) {
                        if (!focusStatus) return;
                        setState(() {
                          textFieldFocused = focusStatus;
                        });
                      },
                      hintText: "Search",
                      showTopText: false,
                      controller: textEditingController,
                    ),
                    const SizedBox(height: 15),
                    LineLayout(color: Theme.of(context).colorScheme.onBackground),
                    Expanded(
                      child: ScrollableView(
                          physics: const BouncingScrollPhysics(),

                        inlineBottomOrRightPadding: bottomSafeArea(context),
                        scrollBarVisible: false,
                        controller: ScrollController(),
                        child: Column(
                          children: [
                            ItemRowTile(onTap: () => print("tap")),
                            ItemRowTile(onTap: () => print("tap")),
                            ItemRowTile(onTap: () => print("tap")),
                            ItemRowTile(onTap: () => print("tap")),
                            ItemRowTile(onTap: () => print("tap")),
                            ItemRowTile(onTap: () => print("tap")),
                            ItemRowTile(onTap: () => print("tap")),
                            ItemRowTile(onTap: () => print("tap")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // PopButton(
              //   justText: true,
              //   backgroundColor: Theme.of(context).colorScheme.secondary,
              //   textColor: Theme.of(context).colorScheme.onSecondary,
              //   text: "Okay",
              //   onPress: () => Navigator.pop(context),
              //   icon: CupertinoIcons.xmark,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
