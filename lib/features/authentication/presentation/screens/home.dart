import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/styles/typography.dart';
import '../../../feed/presentation/screens/home.dart';
import '../cubit/authentication_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 5);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            top: false,
            child: GestureDetector(
              onTap: () {
                print("Tap");
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    // const ExploreHome(),
                    const ExploreHome(),
                    Container(
                      color: Colors.blue,
                    ),
                    Container(
                      color: Colors.red,
                    ),
                    Container(
                      color: Colors.orange,
                    ),
                    Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                    ),
                    // const PostHome(),
                    // const SearchHome(),
                    // const ProfileHome(),
                  ],
                ),
                bottomNavigationBar: Theme(
                  data: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: TabBar(
                    isScrollable: false,
                    labelStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                    unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
                    labelColor: Theme.of(context).colorScheme.primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.transparent,
                    controller: tabController,
                    enableFeedback: true,
                    tabs: [
                      Tab(
                        text: Responsive.isTablet(context) ? "Explore" : null,
                        icon: const Icon(CupertinoIcons.compass),
                      ),
                      Tab(
                        text: Responsive.isTablet(context) ? "Hot" : null,
                        icon: const Icon(CupertinoIcons.flame),
                      ),
                      Tab(
                        text: Responsive.isTablet(context) ? "Post" : null,
                        icon: const Icon(CupertinoIcons.add),
                      ),
                      Tab(
                        text: Responsive.isTablet(context) ? "Search" : null,
                        icon: const Icon(CupertinoIcons.search),
                      ),
                      Tab(
                        text: Responsive.isTablet(context) ? "Profile" : null,
                        icon: const Icon(CupertinoIcons.profile_circled),
                      )
                    ],
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
