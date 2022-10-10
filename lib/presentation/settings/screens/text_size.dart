import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../shared/layout/appbar.dart';
import '../widgets/text_slider_selector.dart';

class TextSizeScreen extends StatefulWidget {
  const TextSizeScreen({super.key});

  @override
  State<TextSizeScreen> createState() => _TextSizeScreenState();
}

class _TextSizeScreenState extends State<TextSizeScreen> {
  double sliderValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                centerWidget: Text(
                  'Text Size',
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              ScrollableView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSliderSelector(
                        value: sliderValue,
                        onChangeSlider: (newValue) {
                          setState(() {
                            sliderValue = newValue;
                          });
                        },
                      ),
                      const DisclaimerText(
                          verticalPadding: 15, text: "These preferences are saved locally to your device."),
                      const SimulatedBottomSafeArea(),
                      sliderValue > 1.0
                          ? const DisclaimerText(verticalPadding: 15, text: "Boomer mode enabled. HAHAHAHA.")
                          : Container(),
                      const SimulatedBottomSafeArea(),
                    ],
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
