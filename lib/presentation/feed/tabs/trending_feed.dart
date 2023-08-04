// TODO: outdated; old style, complex ui

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/feed/enums.dart';
import '../../../constants/feed/general.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/overlays/snackbar.dart';

class ExploreTrending extends StatefulWidget {
  const ExploreTrending({Key? key}) : super(key: key);

  @override
  State<ExploreTrending> createState() => _ExploreTrendingState();
}

class _ExploreTrendingState extends State<ExploreTrending> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Text("todo");
  }

  @override
  bool get wantKeepAlive => true;
}
