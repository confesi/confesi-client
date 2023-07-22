import 'dart:io';

import '../styles/typography.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../results/failures.dart';
import '../results/successes.dart';

class Sharing {
  Future<Either<Failure, Success>> sharePost(
      BuildContext context, String link, String title, String body, String university, String timeAgo) async {
    // todo: generate link using FCM based on post's id
    try {
      File file = await _screenshot(context, title, body, university, timeAgo);
      Share.shareXFiles([XFile(file.path)], text: link, subject: "Check out this confession!");
      return Right(ApiSuccess());
    } catch (_) {
      return Left(ShareFailure());
    }
  }

  Future<File> _screenshot(BuildContext context, String title, String body, String university, String timeAgo) async {
    final capturedImage = await ScreenshotController().captureFromWidget(
        _buildPost(context, title, body, university, timeAgo),
        delay: const Duration(milliseconds: 10));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/confession.png');
    return await file.writeAsBytes(capturedImage);
  }

  Widget _buildPost(BuildContext context, String title, String body, String university, String timeAgo) {
    return Container(
      width: 400,
      color: Theme.of(context).colorScheme.secondary,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        university,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        timeAgo,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: kBody.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned.fill(
            bottom: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Confesi.com",
                style: kTitle.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
