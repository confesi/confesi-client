import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Faded text style - meant for decorative background numbers or display values. Not for primary reading.
var kFaded = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 105, fontWeight: FontWeight.bold),
);

/// Largest text style - meant for BOLD DISPLAY, but with sans serif style.
var kSansSerifDisplay = GoogleFonts.inter(
  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
);

/// Largest text style - meant for BOLD DISPLAY!
var kDisplay = GoogleFonts.dmSerifDisplay(
  textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
);

/// Very big text style.
var kHeader = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
);

/// Big text style.
var kTitle = GoogleFonts.inter(
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
