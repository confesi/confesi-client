const bool kProductionBuild =
    false; // state only loads property (for some reason?) with this being "TRUE" (production build)
const String kDomain = "http://192.168.1.100:3000";
const int kTabletBreakpoint = 1000;
const int kAccessTokenLifetime = 10000; // Normally set to 1800000 (30 minutes) for production
const int kPasswordMinLength = 8;
const int kPasswordMaxLength = 100;
const int kEmailMinLength = 3;
const int kEmailMaxLength = 255;
const int kUsernameMinLength = 3;
const int kUsernameMaxLength = 30;
