import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchableopacity.dart';

class LongTextField extends StatefulWidget {
  LongTextField({required this.focusNode, Key? key}) : super(key: key);

  final FocusNode focusNode;

  @override
  State<LongTextField> createState() => _LongTextFieldState();
}

String text = "";

class _LongTextFieldState extends State<LongTextField> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.focusNode.requestFocus(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.search,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    focusNode: widget.focusNode,
                    controller: controller,
                    onChanged: (newValue) {
                      setState(() {
                        text = newValue;
                      });
                    },
                    style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w100),
                    decoration: InputDecoration.collapsed(
                      hintText: "Search",
                      hintStyle: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: text.isNotEmpty
                      ? TouchableOpacity(
                          onTap: () {
                            setState(() {
                              text = "";
                              controller.clear();
                            });
                          },
                          child: Icon(
                            CupertinoIcons.xmark_circle,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
