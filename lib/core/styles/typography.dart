import 'package:flutter/cupertino.dart' as f;
import 'package:google_fonts/google_fonts.dart' as gf;

/// Faded text style - meant for decorative background numbers or display values. Not for primary reading.
var kFaded = gf.GoogleFonts.inter(
  textStyle: const f.TextStyle(fontSize: 105, fontWeight: f.FontWeight.bold),
);

/// Faded text style - meant for decorative background numbers or display values. Not for primary reading.
var kSplashScreenLogo = gf.GoogleFonts.montserrat(
  textStyle: const f.TextStyle(fontSize: 105, fontWeight: f.FontWeight.bold),
);

/// Large text style - meant for display, but with sans serif style.
var kDisplay1 = gf.GoogleFonts.inter(
  textStyle: const f.TextStyle(fontWeight: f.FontWeight.w600, fontSize: 26),
);

/// Very big text style.
var kDisplay2 = gf.GoogleFonts.inter(
  textStyle: const f.TextStyle(fontSize: 34, fontWeight: f.FontWeight.w600),
);

/// Big text style.
var kTitle = gf.GoogleFonts.inter(
  textStyle: const f.TextStyle(fontSize: 17, fontWeight: f.FontWeight.w600),
);

/// Normal text style.
var kBody = gf.GoogleFonts.inter(
  textStyle: const f.TextStyle(fontSize: 17, fontWeight: f.FontWeight.normal, height: 1.5),
);

/// Details/small text style.
var kDetail = gf.GoogleFonts.inter(
  textStyle: const f.TextStyle(fontSize: 15, fontWeight: f.FontWeight.normal, height: 1.5),
);
