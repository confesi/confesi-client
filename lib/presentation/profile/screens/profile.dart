import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../authentication/cubit/authentication_cubit.dart';

// TODO: Remove the crossing of layers - maybe move the authentication cubit to core?

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => context.read<AuthenticationCubit>().logoutUser(),
            child: const Text("logout"),
          ),
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              return Text("State: $state");
            },
          ),
        ],
      ),
    );
  }
}
