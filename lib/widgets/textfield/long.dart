import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';

class LongTextField extends StatefulWidget {
  const LongTextField(
      {this.bottomPadding = 0.0, this.topPadding = 0.0, this.horizontalPadding = 0.0, Key? key})
      : super(key: key);

  final double bottomPadding;
  final double topPadding;
  final double horizontalPadding;

  @override
  State<LongTextField> createState() => _LongTextFieldState();
}

String text = "";

class _LongTextFieldState extends State<LongTextField> {
  final TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.horizontalPadding,
          right: widget.horizontalPadding,
          top: widget.topPadding,
          bottom: widget.bottomPadding),
      child: GestureDetector(
        onTap: () => focusNode.requestFocus(),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  CupertinoIcons.search,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: (newValue) {
                      setState(() {
                        text = newValue;
                      });
                    },
                    style: kBody.copyWith(
                        color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w100),
                    decoration: InputDecoration.collapsed(
                      hintText: "Search",
                      hintStyle: kBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
