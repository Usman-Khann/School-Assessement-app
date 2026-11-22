import 'package:flutter/material.dart';

import '../core/core.dart';
import '../data/repos/library_repo.dart';
import '../services/app.dart';
import 'theme.dart';

const kGood = Color(0xFF2E7D32);
const kBad = Color(0xFFC62828);
const kWarn = Color(0xFFEF6C00);

Color pctColor(double p) => p >= 70 ? kGood : (p >= 40 ? kWarn : kBad);

/// Keeps content readable on tablets by limiting line width.
class Body extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const Body({super.key, required this.child, this.maxWidth = 760});
  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth), child: child));
}

/// Text whose direction follows its own script (Urdu RTL, English LTR).
class ContentText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const ContentText(this.text, {super.key, this.style});
  @override
  Widget build(BuildContext context) {
    final rtl = isRtlText(text);
    return SizedBox(
        width: double.infinity,
        child: Text(text,
            textDirection: dirOf(text),
            textAlign: rtl ? TextAlign.right : TextAlign.left,
            style: rtl ? (style ?? const TextStyle()).copyWith(height: 1.9) : style));
  }
}

class OnlineChip extends StatelessWidget {
  const OnlineChip({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: App.online,
      builder: (_, on, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Chip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(on ? Icons.wifi : Icons.wifi_off,
                  size: 16, color: on ? kGood : Colors.grey.shade700),
              label: Text(on ? tr('Online', 'آن لائن') : tr('Offline', 'آف لائن')))));
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)));
}

class PctBar extends StatelessWidget {
  final String label;
  final int correct;
  final int total;
  const PctBar(
      {super.key, required this.label, required this.correct, required this.total});
  @override
  Widget build(BuildContext context) {
    final p = total == 0 ? 0.0 : correct * 100.0 / total;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(label, textDirection: dirOf(label))),
            Text('$correct/$total  ${fmtPct(p)}',
                style: TextStyle(fontWeight: FontWeight.bold, color: pctColor(p))),
          ]),
          const SizedBox(height: 3),
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: p / 100,
                  minHeight: 8,
                  color: pctColor(p),
                  backgroundColor: Colors.grey.shade300)),
        ]));
  }
}

class EmptyHint extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? action;
  const EmptyHint({super.key, required this.icon, required this.text, this.action});
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ])));
}

class GradeChips extends StatelessWidget {
  final int? value;
  final bool allowAll;
  final ValueChanged<int?> onChanged;
  const GradeChips(
      {super.key, required this.value, required this.onChanged, this.allowAll = false});
  @override
  Widget build(BuildContext context) => Wrap(spacing: 6, runSpacing: 4, children: [
        if (allowAll)
          ChoiceChip(
              label: Text(tr('All', 'تمام')),
              selected: value == null,
              onSelected: (_) => onChanged(null)),
        for (final g in kGrades)
          ChoiceChip(
              label: Text(gradeLabel(g)),
              selected: value == g,
              selectedColor: gradeColor(g).withValues(alpha: 0.22),
              avatar: CircleAvatar(
                  backgroundColor: gradeColor(g),
                  child: Text('$g',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
              showCheckmark: false,
              onSelected: (_) => onChanged(g)),
      ]);
}

void snack(BuildContext c, String msg) => ScaffoldMessenger.of(c)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(msg)));

Future<bool> confirm(BuildContext c, String title, String body) async =>
    await showDialog<bool>(
        context: c,
        builder: (d) => AlertDialog(
                title: Text(title),
                content: Text(body),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(d, false),
                      child: Text(tr('Cancel', 'منسوخ'))),
                  FilledButton(
                      onPressed: () => Navigator.pop(d, true),
                      child: Text(tr('Yes', 'جی ہاں'))),
                ])) ??
    false;

int? parseInt(String s) => int.tryParse(s.trim());

/// Chapter / topic tree with checkboxes. Ticking a chapter selects the whole
/// chapter; individual topics can be ticked instead. [counts] (optional)
/// shows how many questions each chapter has in the bank.
class ContentPicker extends StatelessWidget {
  final List<ChapterWithTopics> chapters;
  final ContentSelection selection;
  final Map<String, int> counts;
  final VoidCallback onChanged;
  const ContentPicker(
      {super.key,
      required this.chapters,
      required this.selection,
      required this.onChanged,
      this.counts = const {}});

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(tr('This book has no chapters yet. Add them in the Library.',
              'اس کتاب میں ابھی ابواب نہیں ہیں۔ لائبریری میں شامل کریں۔')));
    }
    final allOn = chapters.every((c) => selection.chapterIds.contains(c.chapter.id));
    return Column(children: [
      CheckboxListTile(
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(tr('Select all chapters', 'تمام ابواب منتخب کریں'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          value: allOn,
          onChanged: (v) {
            selection.topicIds.clear();
            selection.chapterIds.clear();
            if (v == true) {
              selection.chapterIds.addAll(chapters.map((c) => c.chapter.id));
            }
            onChanged();
          }),
      for (final c in chapters) _chapter(c),
    ]);
  }

  Widget _chapter(ChapterWithTopics c) {
    final id = c.chapter.id;
    final whole = selection.chapterIds.contains(id);
    final some = c.topics.any((t) => selection.topicIds.contains(t.id));
    final n = counts[id] ?? 0;
    final title = '${c.chapter.number}. ${c.chapter.title}';
    final head = CheckboxListTile(
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        tristate: true,
        value: whole ? true : (some ? null : false),
        title: Text(title, textDirection: dirOf(title)),
        subtitle: counts.isEmpty
            ? null
            : Text('$n ${tr('questions', 'سوالات')}',
                style: TextStyle(color: n == 0 ? kBad : null)),
        onChanged: (_) {
          for (final t in c.topics) {
            selection.topicIds.remove(t.id);
          }
          if (whole) {
            selection.chapterIds.remove(id);
          } else {
            selection.chapterIds.add(id);
          }
          onChanged();
        });
    if (c.topics.isEmpty) return head;
    return Column(children: [
      head,
      for (final t in c.topics)
        Padding(
            padding: const EdgeInsetsDirectional.only(start: 32),
            child: CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                value: whole || selection.topicIds.contains(t.id),
                title: Text(t.title, textDirection: dirOf(t.title)),
                onChanged: (v) {
                  if (whole) {
                    // Switch from "whole chapter" to "all topics but this".
                    selection.chapterIds.remove(id);
                    selection.topicIds
                        .addAll(c.topics.map((e) => e.id).where((e) => e != t.id));
                  } else if (v == true) {
                    selection.topicIds.add(t.id);
                  } else {
                    selection.topicIds.remove(t.id);
                  }
                  onChanged();
                })),
    ]);
  }
}


/// Circular score indicator coloured by performance.
class ScoreRing extends StatelessWidget {
  final double percent;
  final double size;
  const ScoreRing({super.key, required this.percent, this.size = 88});
  @override
  Widget build(BuildContext context) {
    final c = pctColor(percent);
    return SizedBox(
        width: size,
        height: size,
        child: Stack(alignment: Alignment.center, children: [
          SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                  value: (percent / 100).clamp(0, 1),
                  strokeWidth: size * 0.1,
                  strokeCap: StrokeCap.round,
                  color: c,
                  backgroundColor: c.withValues(alpha: 0.15))),
          Text(fmtPct(percent),
              style: TextStyle(
                  fontSize: size * 0.24, fontWeight: FontWeight.w800, color: c)),
        ]));
  }
}
