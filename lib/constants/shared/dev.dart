// If true, it means the app will be viewed inside an emulated device on-screen.
const bool kPreviewMode = false;

// Developer mode. MUST BE OFF ON RELEASE. THIS IS A DANGEROUS BOOL.
const bool devMode = false;

/// The root endpoint (domain) for all api calls.
///
/// This local address will need to change
/// depending on your operating system, and if you're running on a physical device or emulator.
/// "http://10.0.0.173:3000"; // -> MacOS emulator
/// "http://localhost:3000"; // -> iOS emulator
/// "http://10.0.0.173:3000"; // -> Android & iOS physical device
const String kDomain =
    "http://10.0.0.173:3000"; // -> Android & iOS physical device


