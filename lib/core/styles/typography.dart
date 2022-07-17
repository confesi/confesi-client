import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// largest - meant for BOLD DISPLAY!
var kDisplay = GoogleFonts.dmSerifDisplay(
  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
);

// very big
var kHeader = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
);

// big
var kTitle = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
);

// normal text
var kBody = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
);

// detailed or small text
var kDetail = GoogleFonts.inter(
  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
);
