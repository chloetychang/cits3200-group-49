import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

String? tabTitle(int? index) {
  const titles = [
    "Acquisitions",
    "Plantings",
    "Research Family",
    "Progeny",
    "Varieties",
    "Provenances",
    "Suppliers",
    "Users",
    "Zone",
    "Sub-Zones"
  ];
  if (index != null && index >= 0 && index < titles.length) {
    return titles[index];
  }
  return "Table Title"; // fallback
}
