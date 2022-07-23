import 'package:Confessi/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Hero(
            tag: "logo",
            child: Image.asset(
              "assets/images/logo.jpg",
              width: width > 250 ? 250 : width * 2 / 3,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
