import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/state/user_slice.dart';
import 'package:flutter_mobile_client/widgets/buttons/action.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorScreen extends ConsumerStatefulWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends ConsumerState<ErrorScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                const GroupText(
                  header: "Uh oh!",
                  body: "We couldn't connect you to Confessi. Perhaps you have no connection?",
                ),
                const SizedBox(height: 25),
                ActionButton(
                  loading: isLoading,
                  text: "try again",
                  onPress: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Future.delayed(const Duration(milliseconds: 400));
                    ref.read(userProvider.notifier).getAndSetAccessToken();
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
