import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/authentication_cubit.dart';

class TempHome extends StatelessWidget {
  const TempHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: () => context.read<AuthenticationCubit>().logoutUser(),
                child: const Text("logout"),
              ),
            ),
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                return Text("State: $state");
              },
            ),
          ],
        ),
      ),
    );
  }
}
