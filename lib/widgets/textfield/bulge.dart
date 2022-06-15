import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class BulgeTextField extends StatefulWidget {
  const BulgeTextField(
      {this.hintText = "Search",
      this.icon = CupertinoIcons.search,
      this.bottomPadding = 0.0,
      this.topPadding = 0.0,
      this.horizontalPadding = 0.0,
      Key? key})
      : super(key: key);

  final IconData icon;
  final double bottomPadding;
  final String hintText;
  final double topPadding;
  final double horizontalPadding;

  @override
  State<BulgeTextField> createState() => _BulgeTextFieldState();
}

String text = "";

class _BulgeTextFieldState extends State<BulgeTextField> {
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
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 24,
              child: Center(
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
                    hintText: widget.hintText,
                    hintStyle: kBody.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w100),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
