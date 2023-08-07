import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:confesi/models/post.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/services/sharing/sharing.dart';

part 'quick_actions_state.dart';

class QuickActionsCubit extends Cubit<QuickActionsState> {
  QuickActionsCubit(this._sharing) : super(QuickActionsDefault(QuickActionsNoErr()));

  final Sharing _sharing;

  void locateOnMaps(double lat, double long, String title) async {
    if (state is QuickActionsDefault) {
      try {
        final availableMaps = await MapLauncher.installedMaps;
        await availableMaps.first.showMarker(
          coords: Coords(lat, long),
          title: title,
        );
      } catch (_) {
        emit((state as QuickActionsDefault).copyWith(possibleErr: QuickActionsErr("Could not launch maps app")));
      }
    }
  }

  void launchWebsite(String url) async {
    if (state is QuickActionsDefault) {
      try {
        bool success = await launchUrl(Uri.parse(url));
        if (!success) {
          emit((state as QuickActionsDefault).copyWith(possibleErr: QuickActionsErr("Error opening browser")));
        }
      } catch (_) {
        emit((state as QuickActionsDefault).copyWith(possibleErr: QuickActionsErr("Error opening browser")));
      }
    }
  }

  void launchMailClientWithToConfesiPopulated() async {
    if (state is QuickActionsDefault) {
      try {
        await launchUrl(Uri.parse("mailto:$confesiSupportEmail?subject=Confesi"));
      } catch (_) {
        emit((state as QuickActionsDefault).copyWith(possibleErr: QuickActionsErr("Error opening mail client")));
      }
    }
  }

  void launchAppStoresReview() async {
    if (state is QuickActionsDefault) {
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          final appId = Platform.isAndroid ? confesiAndroidPackageName : confesiAppleAppId;
          final url = Uri.parse(
            Platform.isAndroid ? "market://details?id=$appId" : "https://apps.apple.com/app/id$appId",
          );
          launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          emit((state as QuickActionsDefault).copyWith(possibleErr: QuickActionsErr("Platform not supported")));
        }
      } catch (_) {
        emit((state as QuickActionsDefault).copyWith(possibleErr: QuickActionsErr("Error opening store")));
      }
    }
  }

  void sharePost(BuildContext context, Post post) {
    if (state is QuickActionsDefault) {
      _sharing.sharePost(context, post);
    }
  }
}
