import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/presentation/primary/widgets/university_chip.dart';
import 'package:Confessi/presentation/shared/layout/swipebar.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/layout/scrollable_view.dart';

class SelectionTab extends StatefulWidget {
  const SelectionTab({super.key});

  @override
  State<SelectionTab> createState() => _SelectionTabState();
}

class _SelectionTabState extends State<SelectionTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableView(
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      thumbVisible: false,
      child: Container(
        constraints: BoxConstraints(
          minHeight: heightFraction(context, 1),
        ),
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
          top: heightFraction(context, 2 / 7),
          // bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.classicLight.colorScheme.primary.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
          color: AppTheme.classicLight.colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwipebarLayout(color: AppTheme.classicLight.colorScheme.onBackground),
              const SizedBox(height: 15),
              const UniversityChip(text: "University of Victoria"),
              const UniversityChip(text: "Quest University", isSelected: true),
              const UniversityChip(text: "Calgary State"),
              const UniversityChip(text: "Quest University"),
              const UniversityChip(text: "Redeemer"),
            ],
          ),
        ),
      ),
    );
  }
}
