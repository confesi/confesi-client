import 'package:Confessi/presentation/authentication/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: TextButton(
        onPressed: () => context.read<AuthenticationCubit>().logoutUser(),
        child: const Text("TEMP LOGOUT"),
      ),
    );
  }
}
