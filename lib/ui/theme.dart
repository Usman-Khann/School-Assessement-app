import 'package:flutter/material.dart';

import '../core/core.dart';

const kBrand = Color(0xFF0A7D5C); // emerald green
const kBrandDark = Color(0xFF065A42);
const kAccent = Color(0xFFFFB300); // amber
const kBg = Color(0xFFF3F6FB);
const kInk = Color(0xFF1B2733);
const kMuted = Color(0xFF5E6B7A);
const kLine = Color(0xFFE1E7EF);

const kBrandGradient = LinearGradient(
  colors: [Color(0xFF0A7D5C), Color(0xFF12A37A), Color(0xFF1FB58E)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Colour and icon for every subject, used on cards, chips and charts.
class SubjectStyle {
  final Color color;
  final Color light;
  final IconData icon;
  const SubjectStyle(this.color, this.light, this.icon);
  LinearGradient get gradient => LinearGradient(
      colors: [color, Color.lerp(color, Colors.white, 0.25)!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}

SubjectStyle subjectStyle(String s) {
  switch (s) {
    case kMath:
      return const SubjectStyle(Color(0xFF3F51B5), Color(0xFFE8EAF8), Icons.calculate_rounded);
    case 'General Mathematics':
      return const SubjectStyle(Color(0xFF1E88E5), Color(0xFFE3F0FC), Icons.functions_rounded);
    case kScience:
      return const SubjectStyle(Color(0xFF2E7D32), Color(0xFFE5F3E6), Icons.science_rounded);
    case 'Physics':
      return const SubjectStyle(Color(0xFF7B1FA2), Color(0xFFF2E6F7), Icons.bolt_rounded);
    case 'Chemistry':
      return const SubjectStyle(Color(0xFFE65100), Color(0xFFFDEBDD), Icons.biotech_rounded);
    case 'Biology':
      return const SubjectStyle(Color(0xFF00897B), Color(0xFFDFF3F1), Icons.eco_rounded);
    case kUrdu:
      return const SubjectStyle(Color(0xFFAD1457), Color(0xFFF9E2EC), Icons.edit_note_rounded);
    case kEnglish:
      return const SubjectStyle(Color(0xFFC62828), Color(0xFFFBE4E4), Icons.translate_rounded);
    case 'General Knowledge':
      return const SubjectStyle(Color(0xFFF57F17), Color(0xFFFEF3DC), Icons.public_rounded);
  }
  return const SubjectStyle(Color(0xFF546E7A), Color(0xFFECEFF1), Icons.menu_book_rounded);
}

/// Colour for each class, so class chips are easy to tell apart.
Color gradeColor(int g) => const [
      Color(0xFFE53935),
      Color(0xFFFB8C00),
      Color(0xFFFDD835),
      Color(0xFF43A047),
      Color(0xFF00ACC1),
      Color(0xFF1E88E5),
      Color(0xFF5E35B1),
      Color(0xFFD81B60),
    ][(g - 3).clamp(0, 7)];

ThemeData buildTheme(String lang) {
  final ur = lang == 'ur';
  final scheme = ColorScheme.fromSeed(
    seedColor: kBrand,
    primary: kBrand,
    secondary: kAccent,
    surface: Colors.white,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kBg,
    // Nunito has no Urdu letters, so Urdu text automatically falls back to
    // Nastaliq while English text stays in Nunito, in both UI languages.
    fontFamily: 'Nunito',
    fontFamilyFallback: const ['NotoNastaliqUrdu'],
  );
  final t = base.textTheme;
  // Nastaliq letters are tall: give Urdu text more line height.
  TextStyle? w(TextStyle? s, FontWeight fw, [double? size]) => s?.copyWith(
      fontWeight: fw,
      fontSize: size,
      color: kInk,
      height: ur ? 1.9 : 1.3);
  final tt = t.copyWith(
    displaySmall: w(t.displaySmall, FontWeight.w800),
    headlineMedium: w(t.headlineMedium, FontWeight.w800),
    headlineSmall: w(t.headlineSmall, FontWeight.w800),
    titleLarge: w(t.titleLarge, FontWeight.w800),
    titleMedium: w(t.titleMedium, FontWeight.w800),
    titleSmall: w(t.titleSmall, FontWeight.w700),
    bodyLarge: w(t.bodyLarge, FontWeight.w600, 16.5),
    bodyMedium: w(t.bodyMedium, FontWeight.w600, 15),
    bodySmall: w(t.bodySmall, FontWeight.w600)?.copyWith(color: kMuted),
    labelLarge: w(t.labelLarge, FontWeight.w800),
    labelMedium: w(t.labelMedium, FontWeight.w700)?.copyWith(color: kMuted),
    labelSmall: w(t.labelSmall, FontWeight.w700),
  );
  final radius = BorderRadius.circular(16);
  final btnShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  const btnPad = EdgeInsets.symmetric(horizontal: 18, vertical: 14);
  return base.copyWith(
    textTheme: tt,
    appBarTheme: AppBarTheme(
      backgroundColor: kBrand,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: tt.titleLarge?.copyWith(color: Colors.white, height: ur ? 1.6 : 1.2),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
          borderRadius: radius, side: const BorderSide(color: kLine)),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            shape: btnShape,
            padding: btnPad,
            textStyle: tt.labelLarge?.copyWith(fontSize: 16))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            shape: btnShape,
            padding: btnPad,
            side: const BorderSide(color: kBrand, width: 1.5),
            textStyle: tt.labelLarge)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: tt.labelLarge)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kAccent,
      foregroundColor: kInk,
      extendedTextStyle: tt.labelLarge?.copyWith(fontSize: 16),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: tt.labelLarge?.copyWith(fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: const BorderSide(color: kLine),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kLine)),
      labelStyle: tt.bodyMedium?.copyWith(color: kMuted),
    ),
    dividerTheme: const DividerThemeData(color: kLine),
    listTileTheme: ListTileThemeData(
      titleTextStyle: tt.bodyLarge,
      subtitleTextStyle: tt.bodySmall,
    ),
  );
}

/// A rounded square with a gradient and a white icon.
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final double size;
  const GradientIcon(this.icon, this.gradient, {super.key, this.size = 48});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(size * 0.3)),
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      );
}

/// Small coloured pill, e.g. "Class 5" or "Downloaded".
class Pill extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const Pill(this.text, this.color, {super.key, this.icon});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(text,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 12.5)),
        ]),
      );
}
