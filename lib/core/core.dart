import 'dart:math';

import 'package:flutter/widgets.dart';

// ---------- IDs ----------
final _rnd = Random.secure();

/// RFC-4122 version 4 UUID.
String newId() {
  final b = List<int>.generate(16, (_) => _rnd.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  final h = b.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
      '${h.substring(16, 20)}-${h.substring(20)}';
}

String studentCodeFromId(String id) =>
    'STU-${id.replaceAll('-', '').substring(0, 6).toUpperCase()}';

// ---------- Language ----------
/// 'en' or 'ur'. The whole app rebuilds when this changes.
final ValueNotifier<String> appLang = ValueNotifier('en');

/// Tiny two-language string helper: `tr('Students', 'طلبہ')`.
String tr(String en, String ur) => appLang.value == 'ur' ? ur : en;

final _rtlChars = RegExp(r'[֐-ࣿיִ-﷿ﹰ-﻿]');

/// Direction for a piece of *content* (question text etc.), independent of
/// the UI language, so Urdu questions render RTL inside an English UI.
TextDirection dirOf(String s) =>
    _rtlChars.hasMatch(s) ? TextDirection.rtl : TextDirection.ltr;

bool isRtlText(String s) => _rtlChars.hasMatch(s);

// ---------- Curriculum constants ----------
const List<int> kGrades = [3, 4, 5, 6, 7, 8, 9, 10];

const kUrdu = 'Urdu';
const kEnglish = 'English';
const kMath = 'Mathematics';
const kScience = 'General Science';

/// DEFAULT subject list per grade. This is a starting point only and must be
/// verified against the current Punjab Scheme of Studies; teachers can add
/// any other subject when adding a book (see Library > Add book).
List<String> defaultSubjectsFor(int grade) {
  if (grade == 3) return const [kUrdu, kEnglish, kMath, 'General Knowledge'];
  if (grade <= 8) return const [kUrdu, kEnglish, kMath, kScience];
  return const [
    kUrdu,
    kEnglish,
    kMath,
    kScience,
    'Physics',
    'Chemistry',
    'Biology'
  ];
}

String subjectLabel(String s) {
  switch (s) {
    case kUrdu:
      return tr('Urdu', 'اردو');
    case kEnglish:
      return tr('English', 'انگریزی');
    case kMath:
      return tr('Mathematics', 'ریاضی');
    case kScience:
      return tr('General Science', 'جنرل سائنس');
    case 'General Knowledge':
      return tr('General Knowledge', 'معلوماتِ عامہ');
    case 'Physics':
      return tr('Physics', 'طبیعیات');
    case 'Chemistry':
      return tr('Chemistry', 'کیمیا');
    case 'Biology':
      return tr('Biology', 'حیاتیات');
  }
  return s;
}

String gradeLabel(int g) => tr('Class $g', 'جماعت $g');

String difficultyLabel(int d) => d <= 1
    ? tr('Easy', 'آسان')
    : d == 2
        ? tr('Medium', 'درمیانہ')
        : tr('Hard', 'مشکل');

const kQuestionTypes = ['mcq', 'short', 'long', 'fill', 'tf'];

String typeLabel(String t) {
  switch (t) {
    case 'mcq':
      return tr('MCQs', 'کثیر الانتخابی سوالات');
    case 'short':
      return tr('Short Questions', 'مختصر سوالات');
    case 'long':
      return tr('Long Questions', 'تفصیلی سوالات');
    case 'fill':
      return tr('Fill in the Blanks', 'خالی جگہ پُر کریں');
    case 'tf':
      return tr('True / False', 'درست / غلط');
  }
  return t;
}

String fmtDate(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}-${two(d.month)}-${d.year} ${two(d.hour)}:${two(d.minute)}';
}

String fmtPct(double p) =>
    p == p.roundToDouble() ? '${p.round()}%' : '${p.toStringAsFixed(1)}%';
