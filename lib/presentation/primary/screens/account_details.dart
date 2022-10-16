import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:flutter/material.dart';

import '../../shared/layout/segment_selector.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  late SegementSelectorController controller;

  @override
  void initState() {
    controller = SegementSelectorController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OneThemeStatusBar(
      brightness: Brightness.light,
      child: Scaffold(
        body: Center(
          child: SegmentSelector(
            controller: controller,
            onTap: (pageIndex) {
              print(pageIndex);
            },
          ),
        ),
      ),
    );
  }
}
