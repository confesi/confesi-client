import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Faded text style - meant for decorative background numbers or display values. Not for primary reading.
var kFaded = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 105, fontWeight: FontWeight.bold),
);

/// Faded text style - meant for decorative background numbers or display values. Not for primary reading.
var kSplashScreenLogo = GoogleFonts.arimaMadurai(
  textStyle: const TextStyle(fontSize: 105, fontWeight: FontWeight.bold),
);

/// Large text style - meant for display, but with sans serif style.
var kDisplay1 = GoogleFonts.inter(
  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
);

/// Very big text style.
var kDisplay2 = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
);

/// Big text style.
var kTitle = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
);

/// Normal text style.
var kBody = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
);

/// Details/small text style.
var kDetail = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
);
