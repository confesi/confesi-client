import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

// very big
var kHeader = GoogleFonts.inter(
  textStyle: const TextStyle(color: kPrimary, fontSize: 16, fontWeight: FontWeight.bold),
);

// big
var kTitle = GoogleFonts.inter(
  textStyle: const TextStyle(color: kPrimary, fontSize: 16, fontWeight: FontWeight.w500),
);

// normal text
var kBody = GoogleFonts.inter(
  textStyle: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.normal),
);

// detailed or small text
var kDetail = GoogleFonts.inter(
  textStyle: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.normal),
);
