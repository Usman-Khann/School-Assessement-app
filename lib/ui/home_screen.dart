import 'package:flutter/material.dart';

import '../core/core.dart';
import '../services/app.dart';
import 'assess_setup_screen.dart';
import 'common.dart';
import 'library_screen.dart';
import 'paper_screen.dart';
import 'settings_screen.dart';
import 'students_screen.dart';
import 'theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _school = '';
  int _students = 0, _books = 0, _mcqs = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
    if (!App.setupDone) {
      // Optional one-time profile. Can be skipped entirely.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SettingsScreen(firstRun: true)));
        _loadStats();
      });
    }
  }

  Future<void> _loadStats() async {
    final school = await App.school();
    final students = (await App.students.list()).length;
    final books = (await App.library.watchBooks().first).length;
    final mcqs = await App.library.mcqCount();
    if (mounted) {
      setState(() {
        _school = school.name;
        _students = students;
        _books = books;
        _mcqs = mcqs;
      });
    }
  }

  Future<void> _go(Widget w) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => w));
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _Tile(Icons.quiz_rounded, tr('Assess a Student', 'طالب علم کا جائزہ'),
          tr('MCQ test with explanations', 'وضاحت کے ساتھ ٹیسٹ'),
          const [Color(0xFF0A7D5C), Color(0xFF26C09A)],
          () => _go(const AssessSetupScreen())),
      _Tile(Icons.groups_rounded, tr('Students', 'طلبہ'),
          tr('Register, search, progress', 'اندراج، تلاش، کارکردگی'),
          const [Color(0xFF3F51B5), Color(0xFF7986CB)],
          () => _go(const StudentsScreen())),
      _Tile(Icons.auto_stories_rounded, tr('Textbooks', 'درسی کتب'),
          tr('Official books, chapters, MCQs', 'سرکاری کتب، ابواب، سوالات'),
          const [Color(0xFFE65100), Color(0xFFFFA040)],
          () => _go(const LibraryScreen())),
      _Tile(Icons.description_rounded, tr('Exam Papers', 'امتحانی پرچے'),
          tr('Create, print and share', 'بنائیں، پرنٹ اور شیئر کریں'),
          const [Color(0xFFAD1457), Color(0xFFEC6A9C)],
          () => _go(const PaperListScreen())),
      _Tile(Icons.settings_rounded, tr('Settings', 'ترتیبات'),
          tr('School, language, updates', 'اسکول، زبان، اپ ڈیٹ'),
          const [Color(0xFF455A64), Color(0xFF8A9BA5)],
          () => _go(const SettingsScreen())),
    ];
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
            child: Container(
          decoration: const BoxDecoration(
              gradient: kBrandGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28))),
          child: SafeArea(
              bottom: false,
              child: Body(
                  maxWidth: 900,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 12, 22),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.school_rounded,
                                  color: Colors.white, size: 30),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(tr('School Assessment', 'اسکول جائزہ'),
                                      style: text.titleLarge
                                          ?.copyWith(color: Colors.white))),
                              const OnlineChip(),
                            ]),
                            const SizedBox(height: 14),
                            Text(tr('Assalam-o-Alaikum!', 'السلام علیکم!'),
                                style: text.headlineSmall
                                    ?.copyWith(color: Colors.white)),
                            Text(
                                _school.isEmpty
                                    ? tr('Classes 3 to 10 • Punjab textbooks',
                                        'جماعت 3 تا 10 • پنجاب کی درسی کتب')
                                    : _school,
                                style: text.bodyLarge?.copyWith(color: Colors.white)),
                            const SizedBox(height: 16),
                            Row(children: [
                              _Stat('$_students', tr('Students', 'طلبہ')),
                              _Stat('$_books', tr('Books', 'کتب')),
                              _Stat('$_mcqs', tr('MCQs', 'سوالات')),
                            ]),
                          ])))),
        )),
        SliverToBoxAdapter(
            child: Body(
                maxWidth: 900,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(children: [
                      LayoutBuilder(builder: (_, c) {
                        final cols = c.maxWidth > 700 ? 3 : 2;
                        return GridView(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                // Nastaliq script needs more height than English.
                                mainAxisExtent: appLang.value == 'ur' ? 196 : 172),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: tiles);
                      }),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFF4D6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFD975))),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.phone_android_rounded,
                                  color: Color(0xFF8A5A00)),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(tr(
                                      'Guest mode: no account needed. Everything is saved on this phone and works without internet. Records do not move to another phone automatically.',
                                      'مہمان موڈ: اکاؤنٹ کی ضرورت نہیں۔ تمام ریکارڈ اسی موبائل میں محفوظ ہے اور انٹرنیٹ کے بغیر چلتا ہے۔ یہ خود بخود دوسرے موبائل پر منتقل نہیں ہوگا۔'))),
                            ]),
                      ),
                    ])))),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(
      child: Container(
          margin: const EdgeInsetsDirectional.only(end: 8),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          ])));
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final List<Color> colors;
  final VoidCallback onTap;
  const _Tile(this.icon, this.title, this.sub, this.colors, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientIcon(icon, LinearGradient(colors: colors), size: 46),
                      const Spacer(),
                      Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(sub,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall),
                    ]))));
  }
}
