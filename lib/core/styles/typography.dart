import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Faded text style - meant for decorative background numbers or display values. Not for primary reading.
var kFaded = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 105, fontWeight: FontWeight.bold),
);

/// Large text style - meant for display, but with sans serif style.
var kSerifDisplay = GoogleFonts.ibmPlexSerif(
  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
);

/// Largest text style - meant for BOLD DISPLAY!
var kDisplay = GoogleFonts.dmSerifDisplay(
  textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
);

/// Very big text style.
var kHeader = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
);

/// Big text style.
var kTitle = GoogleFonts.ibmPlexSerif(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
);

/// Normal text style.
var kBody = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
);

/// Details/small text style.
var kDetail = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
);
