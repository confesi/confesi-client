import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/typography.dart';
import '../../state/token_slice.dart';
import '../../widgets/buttons/action.dart';
import '../auth/open.dart';
import 'bottom_nav.dart';

class ErrorScreen extends ConsumerStatefulWidget {
  const ErrorScreen({required this.message, Key? key}) : super(key: key);

  final String message;

  @override
  ConsumerState<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends ConsumerState<ErrorScreen> {
  bool isLoading = false;
  late String updatableMessage;

  @override
  void initState() {
    updatableMessage = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TokenState>(tokenProvider, (TokenState? prevState, TokenState newState) {
      print("error LISTENER CALLED, prev: ${prevState!.screen}, new: ${newState.screen}");
      switch (newState.screen) {
        case ScreenState.open:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const OpenScreen()),
              (Route<dynamic> route) => false);
          break;
        case ScreenState.home:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomNav()),
              (Route<dynamic> route) => false);
          break;
        default:
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  updatableMessage,
                  style: kDisplay.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ActionButton(
                  loading: isLoading,
                  text: "try again",
                  onPress: () async {
                    print("Current screen: ${ref.read(tokenProvider).screen.toString()}");
                    setState(() {
                      isLoading = true;
                    });
                    await Future.delayed(const Duration(milliseconds: 400));
                    await ref.read(tokenProvider.notifier).getAndSetAccessToken();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  icon: CupertinoIcons.refresh,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
