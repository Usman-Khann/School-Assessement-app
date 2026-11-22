import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/core.dart';
import '../data/db/database.dart';
import '../data/repos/student_repo.dart';
import 'paper_generator.dart';
import 'progress_engine.dart';

/// Builds PDFs fully on-device.
///
/// English output uses the built-in PDF fonts. Urdu uses the Noto Naskh
/// Arabic font bundled in assets/fonts (the PDF engine cannot join Nastaliq
/// letters correctly, so Naskh is used inside PDFs; the app screens use
/// Nastaliq). Everything works offline.
class PdfBuilder {
  static pw.Font? _urdu;
  static pw.Font? _urduBold;

  /// Returns false when Urdu text is present but no Urdu font is available.
  static Future<bool> _ensureFonts(bool needUrdu) async {
    if (!needUrdu || _urdu != null) return true;
    try {
      // Bundled with the app, so Urdu PDFs work offline.
      _urdu = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoNaskhArabic-400.ttf'));
      _urduBold = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoNaskhArabic-700.ttf'));
      return true;
    } catch (_) {
      try {
        _urdu = await PdfGoogleFonts.notoNaskhArabicRegular();
        _urduBold = await PdfGoogleFonts.notoNaskhArabicBold();
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  static pw.ThemeData _theme() => _urdu == null
      ? pw.ThemeData.base()
      : pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
          fontFallback: [_urdu!, if (_urduBold != null) _urduBold!]);

  static pw.Widget _t(String s, {double size = 11, bool bold = false}) {
    final rtl = isRtlText(s);
    return pw.Text(s,
        textDirection: rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        textAlign: rtl ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
            fontSize: size,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            font: rtl ? (bold ? _urduBold ?? _urdu : _urdu) : null));
  }

  static bool _paperNeedsUrdu(GeneratedPaper p) =>
      p.config.language == 'ur' ||
      isRtlText(p.config.title) ||
      isRtlText(p.config.schoolName) ||
      p.sections.values.expand((e) => e).any(
          (q) => isRtlText(q.text) || q.options.any(isRtlText) || isRtlText(q.answer));

  static String _h(PaperConfig c, String en, String ur) =>
      c.language == 'ur' && _urdu != null ? ur : en;

  static String _sectionTitle(PaperConfig c, String type) {
    switch (type) {
      case 'mcq':
        return _h(c, 'Multiple Choice Questions', 'کثیر الانتخابی سوالات');
      case 'fill':
        return _h(c, 'Fill in the Blanks', 'خالی جگہ پُر کریں');
      case 'tf':
        return _h(c, 'True / False', 'درست / غلط');
      case 'short':
        return _h(c, 'Short Questions', 'مختصر سوالات');
      default:
        return _h(c, 'Long Questions', 'تفصیلی سوالات');
    }
  }

  static pw.Widget _header(GeneratedPaper p, {String? suffix}) {
    final c = p.config;
    return pw.Column(children: [
      if (c.schoolName.isNotEmpty)
        pw.Center(child: _t(c.schoolName, size: 16, bold: true)),
      pw.Center(
          child: _t(suffix == null ? c.title : '${c.title} - $suffix',
              size: 14, bold: true)),
      pw.SizedBox(height: 6),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        _t('${_h(c, 'Class', 'جماعت')}: ${c.grade}'),
        _t('${_h(c, 'Subject', 'مضمون')}: ${c.subject}'),
        _t('${_h(c, 'Time', 'وقت')}: ${c.durationMin} ${_h(c, 'min', 'منٹ')}'),
        _t('${_h(c, 'Total Marks', 'کل نمبر')}: ${p.totalMarks}'),
      ]),
      pw.Divider(),
    ]);
  }

  /// The student-facing question paper (no answers).
  static Future<Uint8List> paper(GeneratedPaper p) async {
    await _ensureFonts(_paperNeedsUrdu(p));
    final c = p.config;
    final doc = pw.Document(theme: _theme());
    final body = <pw.Widget>[
      _header(p),
      pw.Row(children: [
        pw.Expanded(
            child: _t('${_h(c, 'Name', 'نام')}: ______________________')),
        pw.Expanded(
            child: _t('${_h(c, 'Roll No.', 'رول نمبر')}: ____________')),
        pw.Expanded(child: _t('${_h(c, 'Date', 'تاریخ')}: ____________')),
      ]),
      pw.SizedBox(height: 10),
    ];
    var sec = 0;
    for (final type in kPaperOrder) {
      final qs = p.sections[type];
      if (qs == null || qs.isEmpty) continue;
      sec++;
      final marks = qs.fold<int>(0, (s, q) => s + q.marks);
      body.add(pw.Container(
          margin: const pw.EdgeInsets.only(top: 8, bottom: 4),
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _t('${_h(c, 'Section', 'حصہ')} ${String.fromCharCode(64 + sec)}: ${_sectionTitle(c, type)}',
                    size: 12, bold: true),
                _t('(${qs.length} x ${qs.first.marks} = $marks)', bold: true),
              ])));
      for (var i = 0; i < qs.length; i++) {
        final q = qs[i];
        final rtl = isRtlText(q.text);
        body.add(pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Column(
                crossAxisAlignment: rtl
                    ? pw.CrossAxisAlignment.end
                    : pw.CrossAxisAlignment.start,
                children: [
                  _t('${i + 1}. ${q.text}'),
                  if (type == 'mcq')
                    pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 14, top: 2),
                        child: pw.Wrap(
                            spacing: 18,
                            runSpacing: 2,
                            children: [
                              for (var k = 0; k < q.options.length; k++)
                                _t('(${String.fromCharCode(65 + k)}) ${q.options[k]}')
                            ])),
                  if (type == 'tf')
                    pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 14, top: 2),
                        child: _t(_h(c, 'True  /  False', 'درست  /  غلط'))),
                  if (type == 'long') pw.SizedBox(height: 4),
                ])));
      }
    }
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => body));
    return doc.save();
  }

  /// Teacher-only answer key and marking scheme.
  static Future<Uint8List> answerKey(GeneratedPaper p) async {
    await _ensureFonts(_paperNeedsUrdu(p));
    final c = p.config;
    final doc = pw.Document(theme: _theme());
    final body = <pw.Widget>[
      _header(p,
          suffix: _h(c, 'ANSWER KEY & MARKING SCHEME (Teacher copy)',
              'جوابات اور نمبروں کی تقسیم (برائے استاد)')),
    ];
    var sec = 0;
    for (final type in kPaperOrder) {
      final qs = p.sections[type];
      if (qs == null || qs.isEmpty) continue;
      sec++;
      body.add(pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
          child: _t(
              '${_h(c, 'Section', 'حصہ')} ${String.fromCharCode(64 + sec)}: ${_sectionTitle(c, type)} - ${qs.first.marks} ${_h(c, 'mark(s) each', 'نمبر فی سوال')}',
              size: 12,
              bold: true)));
      for (var i = 0; i < qs.length; i++) {
        final q = qs[i];
        final ans = q.keyAnswer.isEmpty
            ? _h(c, '(no model answer saved for this question)',
                '(اس سوال کا جواب محفوظ نہیں)')
            : q.keyAnswer;
        final ref = [
          if (q.chapterTitle.isNotEmpty) q.chapterTitle,
          if (q.page != null) 'p. ${q.page}'
        ].join(', ');
        body.add(pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _t('${i + 1}. $ans  [${q.marks}]'),
                  if (q.explanation.isNotEmpty) _t(q.explanation, size: 9),
                  if (ref.isNotEmpty) _t('Ref: $ref', size: 8),
                ])));
      }
    }
    body.add(pw.Divider());
    body.add(_t('${_h(c, 'Total Marks', 'کل نمبر')}: ${p.totalMarks}',
        bold: true));
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => body));
    return doc.save();
  }

  /// Per-student progress report.
  static Future<Uint8List> progressReport({
    required Student student,
    required String schoolName,
    required String teacherName,
    required List<SubjectProgress> progress,
  }) async {
    final needUrdu = isRtlText(student.name) ||
        isRtlText(schoolName) ||
        isRtlText(teacherName) ||
        progress.any((p) =>
            p.chapters.any((b) => isRtlText(b.title)) ||
            p.topics.any((b) => isRtlText(b.title)));
    await _ensureFonts(needUrdu);
    final doc = pw.Document(theme: _theme());
    final body = <pw.Widget>[
      if (schoolName.isNotEmpty)
        pw.Center(child: _t(schoolName, size: 16, bold: true)),
      pw.Center(child: _t('Student Progress Report', size: 14, bold: true)),
      pw.SizedBox(height: 8),
      _t('Student: ${studentDisplayName(student)}   ID: ${student.code}'),
      _t('Class: ${student.grade}'
          '${student.section.isEmpty ? '' : '   Section: ${student.section}'}'
          '${student.rollNo.isEmpty ? '' : '   Roll No.: ${student.rollNo}'}'),
      if (teacherName.isNotEmpty) _t('Teacher: $teacherName'),
      _t('Generated: ${fmtDate(DateTime.now())}', size: 9),
      pw.Divider(),
    ];
    if (progress.isEmpty) body.add(_t('No assessments recorded yet.'));
    for (final p in progress) {
      body.add(pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: _t(p.subject, size: 13, bold: true)));
      final d = p.delta;
      body.add(_t('Attempts: ${p.attempts.length}   '
          'Latest: ${fmtPct(p.latest!.percentage)}   '
          '${p.previous == null ? '' : 'Previous: ${fmtPct(p.previous!.percentage)}   '}'
          'Average: ${fmtPct(p.average)}'));
      if (d != null) {
        body.add(_t(
            d > 0
                ? 'Improvement: ${d.abs().toStringAsFixed(d == d.roundToDouble() ? 0 : 1)} percentage points'
                : d < 0
                    ? 'Decline: ${d.abs().toStringAsFixed(d == d.roundToDouble() ? 0 : 1)} percentage points'
                    : 'No change since the previous assessment',
            bold: true));
      }
      body.add(pw.SizedBox(height: 4));
      body.add(pw.TableHelper.fromTextArray(
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerStyle:
              pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          headers: ['Date', 'Score', '%', 'Time (min)'],
          data: [
            for (final a in p.attempts)
              [
                fmtDate(a.finishedAt),
                '${a.correct}/${a.total}',
                fmtPct(a.percentage),
                (a.timeTakenSec / 60).toStringAsFixed(1)
              ]
          ]));
      if (p.chapters.isNotEmpty) {
        body.add(pw.SizedBox(height: 4));
        body.add(_t('Chapter-wise accuracy', bold: true, size: 10));
        for (final b in p.chapters) {
          body.add(
              _t('${b.title}: ${b.correct}/${b.total} (${fmtPct(b.pct)})', size: 9));
        }
      }
      final weak = p.weakAreas;
      if (weak.isNotEmpty) {
        body.add(pw.SizedBox(height: 4));
        body.add(_t('Needs more practice', bold: true, size: 10));
        for (final b in weak) {
          body.add(
              _t('${b.title}: ${b.correct}/${b.total} (${fmtPct(b.pct)})', size: 9));
        }
      }
      if (p.repeated.isNotEmpty) {
        body.add(pw.SizedBox(height: 4));
        body.add(_t('Repeated mistakes', bold: true, size: 10));
        for (final r in p.repeated.take(10)) {
          body.add(_t(
              '${r.question.text} (wrong ${r.timesWrong} of ${r.timesSeen} times)',
              size: 9));
        }
      }
      if (p.latest!.feedback.isNotEmpty) {
        body.add(pw.SizedBox(height: 4));
        body.add(_t('Latest feedback: ${p.latest!.feedback}', size: 9));
      }
    }
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (_) => body));
    return doc.save();
  }
}
