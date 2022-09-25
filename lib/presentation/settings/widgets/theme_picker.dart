import 'package:Confessi/application/shared/themes_cubit.dart';
import 'package:Confessi/presentation/settings/widgets/theme_sample_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/styles/theme_name.dart';

class ThemePicker extends StatefulWidget {
  const ThemePicker({
    super.key,
  });

  @override
  State<ThemePicker> createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(viewportFraction: .4);
    super.initState();
  }

  int selectedIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void animateToIndex(int index) => pageController.animateToPage(index,
      duration: const Duration(milliseconds: 250), curve: Curves.decelerate);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Theme",
            style:
                kTitle.copyWith(color: Theme.of(context).colorScheme.onSurface),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: PageView(
            controller: pageController,
            onPageChanged: (newIndex) {
              HapticFeedback.selectionClick();
              if (newIndex == 0) {
                context.read<ThemesCubit>().setThemeSystem();
              } else if (newIndex == 1) {
                context.read<ThemesCubit>().setThemeDark();
              } else if (newIndex == 2) {
                context.read<ThemesCubit>().setThemeLight();
              }
              setState(() {
                selectedIndex = newIndex;
              });
            },
            children: [
              ThemeSampleCircle(
                onTap: (index) => animateToIndex(index),
                name: "System (${themeName(context)})",
                index: 0,
                selectedIndex: selectedIndex,
                colors: [Colors.yellow, Colors.orange],
              ),
              ThemeSampleCircle(
                onTap: (index) => animateToIndex(index),
                name: "Dark",
                index: 1,
                selectedIndex: selectedIndex,
                colors: [Colors.black, Colors.black],
              ),
              ThemeSampleCircle(
                onTap: (index) => animateToIndex(index),
                name: "Light",
                index: 2,
                selectedIndex: selectedIndex,
                colors: [Colors.white, Colors.white],
              ),
              ThemeSampleCircle(
                onTap: (index) => animateToIndex(index),
                name: "Rainbow",
                index: 3,
                selectedIndex: selectedIndex,
                colors: [Colors.pink, Colors.blue, Colors.green, Colors.orange],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
