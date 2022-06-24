import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/layouts/keyboard_dismiss.dart';
import 'package:flutter_mobile_client/widgets/textfield/long.dart';
import 'package:flutter_mobile_client/widgets/tiles/user.dart';
import '../../constants/typography.dart';

class SearchHome extends StatelessWidget {
  const SearchHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppbarLayout(
                centerWidget: LongTextField(),
                centerWidgetFullWidth: true,
                showIcon: false,
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: const [
                      UserTile(),
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
