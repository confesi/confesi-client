import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Largest text style - meant for BOLD DISPLAY!
var kDisplay = GoogleFonts.dmSerifDisplay(
  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
);

/// Very big text style.
var kHeader = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
