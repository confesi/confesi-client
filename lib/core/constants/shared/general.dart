// TODO: make this file into a "device specific" class

// If true, it means the app will be viewed inside an emulated device on-screen.
const bool kPreviewMode = false;

/// The root endpoint (domain) for all api calls.
///
/// This local address will need to change
/// depending on your operating system, and if you're running on a physical device or emulator.

// const String kDomain = "http://10.0.0.173:3000"; // -> MacOS emulator
// const String kDomain = "http://localhost:3000"; // -> iOS emulator
const String kDomain =
    "http://10.0.0.173:3000"; // -> Android & iOS physical device

//! ADDRESSES FOR DIFFERENT SYSTEMS:

// Physical iOS device: [your computer's ipV4 address]
// iOS simulator: 127.0.0.1
