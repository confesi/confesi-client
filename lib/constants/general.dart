const bool kProductionBuild =
    false; // state only loads property (for some reason?) with this being "TRUE" (production build)
const String kDomain = "http://192.168.1.100:3000";
const int kTabletBreakpoint = 1000;
const int kAccessTokenLifetime =
    1700000; // Normally set to 1800000 (30 minutes) for production (though will this be cutting it too close?)
const int kPasswordMinLength = 8;
const int kPasswordMaxLength = 100;
const int kEmailMinLength = 3;
const int kEmailMaxLength = 255;
const int kUsernameMinLength = 3;
const int kUsernameMaxLength = 30;
const int kPostPreviewCharacters = 250;
const int kReplyingToPostPreviewCharacters = 150;
const kNumberOfPostsToLoad =
    5; // ~IMPORTANT~ this value should be the same as the number of posts the server sends back

