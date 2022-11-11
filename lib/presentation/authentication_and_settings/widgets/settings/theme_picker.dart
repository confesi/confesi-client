import 'theme_sample_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/authentication_and_settings/text.dart';

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
    pageController = PageController(viewportFraction: .4, initialPage: 0);
    super.initState();
  }

  int selectedIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void animateToIndex(int index) =>
      pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.decelerate);

  // void setTheme(int index, BuildContext context) {
  //   if (index == 0) {
  //     context.read<ThemeCubit>().setThemeClassic();
  //   } else if (index == 1) {
  //     context.read<ThemeCubit>().setThemeElegant();
  //   } else if (index == 2) {
  //     context.read<ThemeCubit>().setThemeSalmon();
  //   } else if (index == 3) {
  //     context.read<ThemeCubit>().setThemeSciFi();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          setState(() {
            selectedIndex = newIndex;
          });
          print(newIndex);
          // setTheme(newIndex, context);
        },
        children: [
          ThemeSampleCircle(
            isActive: false, // context.watch<ThemeCubit>().state is ClassicTheme
            onTap: (index) => animateToIndex(index),
            name: kClassicTheme,
            index: 0,
            colors: const [
              Color(0xfffde5b6),
              Color.fromARGB(255, 255, 191, 63),
            ],
          ),
          ThemeSampleCircle(
            onTap: (index) => animateToIndex(index),
            name: kElegantTheme,
            index: 1,
            isActive: false,
            colors: const [
              Color(0xff937DC2),
              Color.fromARGB(255, 104, 39, 245),
            ],
          ),
          ThemeSampleCircle(
            onTap: (index) => animateToIndex(index),
            name: kSalmonTheme,
            index: 2,
            isActive: false,
            colors: const [Color(0xffFA7070), Color.fromARGB(255, 246, 79, 79)],
          ),
          ThemeSampleCircle(
            onTap: (index) => animateToIndex(index),
            name: kSciFiTheme,
            index: 3,
            isActive: false,
            colors: const [Color(0xffABD9FF), Color.fromARGB(255, 42, 154, 245)],
          ),
        ],
      ),
    );
  }
}
