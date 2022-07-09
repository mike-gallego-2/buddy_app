import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// layout
const standardPadding = EdgeInsets.all(16);
const smallPadding = EdgeInsets.all(8);

// textstyles
TextStyle getStyle({double? fontSize, Color? color, FontWeight? fontWeight}) {
  return GoogleFonts.montserrat(
    fontSize: fontSize ?? 16,
    color: color ?? white,
    fontWeight: fontWeight ?? FontWeight.normal,
  );
}

// colors
const white = Color(0xFFFFFFFF);
final lightGrey = Colors.grey[600];
const primary = Color(0xFF032A49);
final senderColor = Colors.grey[600]!.withOpacity(0.3);
final recipientColor = Colors.blue[600]!.withOpacity(0.3);
