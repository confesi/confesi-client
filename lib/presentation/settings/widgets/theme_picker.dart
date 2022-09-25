import 'package:Confessi/application/settings/appearance_cubit.dart';
import 'package:Confessi/application/settings/theme_cubit.dart';
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
    pageController = PageController(
        viewportFraction: .33,
        initialPage:
            context.read<ThemeCubit>().getThemeNumericRepresentation());
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

  void setTheme(int index, BuildContext context) {
    if (index == 0) {
      context.read<ThemeCubit>().setThemeClassic();
    } else if (index == 1) {
      context.read<ThemeCubit>().setThemeElegant();
    } else if (index == 2) {
      context.read<ThemeCubit>().setThemeSalmon();
    } else if (index == 3) {
      context.read<ThemeCubit>().setThemeSciFi();
    }
  }

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
          setTheme(newIndex, context);
        },
        children: [
          ThemeSampleCircle(
            isActive: context.watch<ThemeCubit>().state is ClassicTheme,
            onTap: (index) => animateToIndex(index),
            name: "Classic",
            index: 0,
            colors: const [
              Color(0xfffde5b6),
              Color.fromARGB(255, 255, 191, 63),
            ],
          ),
          ThemeSampleCircle(
            onTap: (index) => animateToIndex(index),
            name: "Elegant",
            index: 1,
            isActive: context.watch<ThemeCubit>().state is ElegantTheme,
            colors: const [
              Color(0xff937DC2),
              Color.fromARGB(255, 104, 39, 245),
            ],
          ),
          ThemeSampleCircle(
            onTap: (index) => animateToIndex(index),
            name: "Salmon",
            index: 2,
            isActive: context.watch<ThemeCubit>().state is SalmonTheme,
            colors: const [Color(0xffFA7070), Color.fromARGB(255, 246, 79, 79)],
          ),
          ThemeSampleCircle(
            onTap: (index) => animateToIndex(index),
            name: "Sci-fi",
            index: 3,
            isActive: context.watch<ThemeCubit>().state is SciFiTheme,
            colors: const [
              Color(0xffABD9FF),
              Color.fromARGB(255, 42, 154, 245)
            ],
          ),
        ],
      ),
    );
  }
}
