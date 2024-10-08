import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../application/create_post/cubit/post_categories_cubit.dart';

/// The root endpoint (domain) for all api calls.
///
/// UVIC: 134.87.37.86 (ephemeral)
/// SHERIDAN: 10.0.0.173 (ephemeral)
const String domain = "http://10.0.0.173:8080";

const Duration apiDefaultTimeout = Duration(seconds: 8);

const int chatPageSize = 15;

const double floatingBottomNavOffset = 0; // 78

/// If debug mode is enabled. OFF for prod.
const bool debugMode = false;

const int maxImagesPerPost = 5;

const double maxStandardSizeOfContent = 500;

const double borderSize = 0.4;

const double imgBlurSigma = 15;

const String walrusHeadImgPath = "assets/images/logos/walrus_head.png";

const String walrusFullBodyImgPath = "assets/images/logos/walrus_full_body.png";

const bool devicePreview = false;

/// Min length for passwords.
const int passwordMinLength = 8;

const int dailyHottestPreviewLength = 50;

const int postTitlePreviewLength = 100;
const int postBodyPreviewLength = 200;

// const int chatMessagePreviewLength = 50;

const int kPostTitleMaxLength = 500;
const int kPostBodyMaxLength = 10000;

const double shrunkViewWidth = 400;
const int rankedSchoolsPageSize = 2;
const int savedContentPageSize = 2;
const int maxCommentLength = 200;
const int commentPreviewLength = 500;

const int postsPageSize = 10;

const int commentSectionRootsLoadedInitially = 10;
const int commentSectionRepliesLoadedInitially = 3;

const List<String> faculties = [
  "ENG",
  "CSC",
  "CHEM",
  "MATH",
  "PHYS",
  "BIO",
  "ECON",
  "PHIL",
  "HIST",
  "SOC",
  "PSYCH",
  "POLI",
  "ANTH",
  "ART",
  "MUS",
  "THEA",
  "LIT",
  "LANG",
  "EDUC",
  "NURS",
  "MED",
  "BIZ",
];

const List<String> yearsOfStudy = [
  "Year one",
  "Year two",
  "Year three",
  "Year four",
  "Year five",
  "Graduate",
  "PhD",
  "Alumni",
  "Faculty",
];

List<PostCategory> postCategories = const [
  PostCategory("General", CupertinoIcons.cube_box),
  PostCategory("Hot takes", CupertinoIcons.flame),
  PostCategory("Classes", CupertinoIcons.book),
  PostCategory("Events", CupertinoIcons.calendar),
  PostCategory("Politics", CupertinoIcons.chat_bubble_2),
  PostCategory("Relationships", CupertinoIcons.suit_heart),
  PostCategory("Wholesome", CupertinoIcons.bandage),
  PostCategory("Marketplace", CupertinoIcons.money_dollar),
];

const int maxNumberOfLinkPreviewsPerPostTile = 3;
const int maxNumberOfLinkPreviewsPerDetailCommentView = 15;

const String confesiSupportEmail = "support@confesi.com";

const String confesiAndroidPackageName = "com.confesi.app";
const String confesiAppleAppId = "com.confesi.app";

// converter using the postCatgories list to convert string to icondata
IconData postCategoryToIcon(String category) {
  for (PostCategory postCategory in postCategories) {
    if (postCategory.name.toLowerCase() == category.toLowerCase()) {
      return postCategory.icon;
    }
  }
  return CupertinoIcons.cube_box; // default
}

String genRandomEmoji(String? notThisOne) {
  List<String> emojis = ['👀', '❤️', '🚀', '😈', '💀'];
  if (notThisOne != null) {
    emojis.remove(notThisOne);
  }
  return emojis[Random().nextInt(emojis.length)];
}
