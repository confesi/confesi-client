import '../../../../core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import 'header_text.dart';

class TextSliderSelector extends StatefulWidget {
  const TextSliderSelector({
    super.key,
    required this.onChangeSlider,
    required this.value,
  });

  final Function(double) onChangeSlider;
  final double value;

  @override
  State<TextSliderSelector> createState() => _TextSliderSelectorState();
}

class _TextSliderSelectorState extends State<TextSliderSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderText(text: kTextSizeChooseMultiplierLabel, textFactor1: true),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    kTextSizeExampleHeaderText,
                    style: const TextStyle(fontSize: 26),
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: widget.value,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    kTextSizeExampleBodyText,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: widget.value,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    kTextSizeExampleDetailText,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: widget.value,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Text(
                "${widget.value.toStringAsFixed(1)}x",
                style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                textScaleFactor: 1,
              ),
            ),
            Expanded(
              flex: 8,
              child: Slider(
                divisions: 10,
                max: 1.5,
                min: 0.5,
                value: widget.value,
                onChanged: (newValue) {
                  HapticFeedback.selectionClick();
                  widget.onChangeSlider(newValue);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
