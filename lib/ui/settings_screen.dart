import 'package:flutter/material.dart';

import '../core/core.dart';
import '../services/app.dart';
import '../services/sync_engine.dart';
import 'common.dart';

/// School / teacher profile (all optional), language and backup status.
/// Shown once on first launch with a Skip button.
class SettingsScreen extends StatefulWidget {
  final bool firstRun;
  const SettingsScreen({super.key, this.firstRun = false});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _school = TextEditingController();
  final _district = TextEditingController();
  final _tehsil = TextEditingController();
  final _teacher = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await App.school();
    final t = await App.teacher();
    _school.text = s.name;
    _district.text = s.district;
    _tehsil.text = s.tehsil;
    _teacher.text = t.name;
    await App.sync.refreshStatus();
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _save() async {
    await App.saveProfile(
        schoolName: _school.text,
        district: _district.text,
        tehsil: _tehsil.text,
        teacherName: _teacher.text);
    if (!mounted) return;
    if (widget.firstRun) {
      Navigator.pop(context);
    } else {
      snack(context, tr('Saved', 'محفوظ ہو گیا'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final opt = tr('(optional)', '(اختیاری)');
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.firstRun
              ? tr('Welcome', 'خوش آمدید')
              : tr('Settings', 'ترتیبات')),
          actions: [
            if (widget.firstRun)
              TextButton(
                  onPressed: () async {
                    await App.markSetupDone();
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(tr('Skip', 'چھوڑیں')))
          ]),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Body(
              child: ListView(padding: const EdgeInsets.all(16), children: [
              if (widget.firstRun)
                Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(tr(
                        'You can fill these in now, later, or never. The app works with all of them blank.',
                        'یہ معلومات ابھی، بعد میں، یا کبھی نہ بھریں — ایپ ان کے بغیر بھی چلتی ہے۔'))),
              SectionTitle(tr('Language', 'زبان')),
              SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'en', label: Text('English')),
                    ButtonSegment(value: 'ur', label: Text('اردو')),
                  ],
                  selected: {appLang.value},
                  onSelectionChanged: (s) => App.setLang(s.first)),
              SectionTitle(tr('School and teacher', 'اسکول اور استاد')),
              for (final f in [
                (_school, tr('School name', 'اسکول کا نام')),
                (_district, tr('District', 'ضلع')),
                (_tehsil, tr('Tehsil', 'تحصیل')),
                (_teacher, tr('Teacher name', 'استاد کا نام')),
              ])
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                        controller: f.$1,
                        decoration: InputDecoration(labelText: '${f.$2} $opt'))),
              FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(tr('Save', 'محفوظ کریں'))),
              if (!widget.firstRun) ...[
                SectionTitle(tr('Textbook content', 'درسی مواد')),
                Card(
                    child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String>(
                                  future: App.content.installedVersion(),
                                  builder: (_, v) => Text(
                                      '${tr('Installed content version', 'موجودہ مواد کا ورژن')}: ${v.data ?? '-'}')),
                              const SizedBox(height: 4),
                              Text(
                                  tr('Chapters, topics, page numbers and MCQs come from eLearn Punjab (official PCTB/PITB site). The MCQs were checked and over 180 wrong official answers were corrected. When online, the app downloads newer content from the project repository automatically.',
                                      'ابواب، موضوعات، صفحہ نمبر اور سوالات ای لرن پنجاب (سرکاری PCTB/PITB ویب سائٹ) سے لیے گئے ہیں۔ سوالات کی جانچ کی گئی اور 180 سے زیادہ غلط سرکاری جوابات درست کیے گئے۔'),
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 8),
                              ValueListenableBuilder<bool>(
                                  valueListenable: App.content.busy,
                                  builder: (_, busy, __) => FilledButton.tonalIcon(
                                      onPressed: busy
                                          ? null
                                          : () async {
                                              final m = await App.content.checkOnline();
                                              if (context.mounted) {
                                                snack(context, m);
                                                setState(() {});
                                              }
                                            },
                                      icon: busy
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(strokeWidth: 2))
                                          : const Icon(Icons.sync_rounded),
                                      label: Text(tr('Check for new content', 'نیا مواد چیک کریں')))),
                            ]))),
                SectionTitle(tr('Cloud backup', 'کلاؤڈ بیک اپ')),
                ValueListenableBuilder<SyncStatus>(
                    valueListenable: App.sync.status,
                    builder: (_, s, __) => Card(
                        child: ListTile(
                            leading: const Icon(Icons.cloud_off),
                            title: Text(tr('Not set up yet', 'ابھی فعال نہیں')),
                            subtitle: Text(tr(
                                'Accounts and cloud backup are planned for a later version. '
                                    'Until then all records are kept safely on this device. '
                                    '${s.pending + s.failed} record(s) are queued for upload once backup is available.',
                                'اکاؤنٹ اور کلاؤڈ بیک اپ آئندہ ورژن میں آئیں گے۔ تب تک تمام ریکارڈ اسی موبائل میں محفوظ ہے۔ '
                                    '${s.pending + s.failed} ریکارڈ اپ لوڈ کے منتظر ہیں۔'))))),
              ],
            ])),
    );
  }
}
