import 'package:flutter/material.dart';

import 'core/palette.dart';
import 'data/word_repository.dart';
import 'models/vocabulary_word.dart';
import 'screens/dashboard_screen.dart';
import 'screens/dictionary_screen.dart';
import 'screens/add_word_screen.dart';
import 'widgets/ui_parts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DilRotasiApp());
}

class DilRotasiApp extends StatelessWidget {
  const DilRotasiApp({super.key, this.repository});
  final WordRepository? repository;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Dil Rotası • Kelime Atölyesi',
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    home: MainShell(repository: repository ?? PreferencesWordRepository()),
  );
}

/// DERSTEKİ ORTAK STATE:
/// _currentTab: seçili ekran
/// _words: her ekrandan kullanılan ortak kelime listesi
/// _dailyGoal: günlük çalışma hedefi
/// _formVersion: başarılı kayıt sonrası formu sıfırlayan key
/// Bütün değişiklikler setState + callback ile yönetiliyor.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.repository});
  final WordRepository repository;
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentTab = 0;
  int _formVersion = 0;
  int _dailyGoal = 5;
  bool _loading = true;
  String? _loadWarning;
  List<VocabularyWord> _words = [];
  Future<void> _saveQueue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final words = await widget.repository.loadWords();
      final goal = await widget.repository.loadDailyGoal();
      if (!mounted) return;
      setState(() {
        _words = words;
        _dailyGoal = goal.clamp(1, 30).toInt();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _words = demoWords();
        _loading = false;
        _loadWarning = 'Yerel kayıt okunamadı. Örnek kelimeler gösteriliyor.';
      });
    }
  }

  void _message(String value) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(value)));
  }

  void _selectTab(int tab) => setState(() => _currentTab = tab);

  void _persistWords() {
    final snapshot = List<VocabularyWord>.of(_words);
    _saveQueue = _saveQueue
        .then((_) => widget.repository.saveWords(snapshot))
        .catchError((Object _) => _message('Kelimeler cihaza kaydedilemedi.'));
  }

  void _addWord(VocabularyWord word) {
    setState(() {
      _words.insert(0, word);
      _currentTab = 1;
      _formVersion++;
    });
    _persistWords();
    _message('“${word.word}” defterine eklendi.');
  }

  void _reviewWord(String id) {
    final index = _words.indexWhere((word) => word.id == id);
    if (index < 0) return;
    setState(() {
      final old = _words[index];
      _words[index] = old.copyWith(
        stage: old.stage.next,
        reviewCount: old.reviewCount + 1,
        lastReviewedAt: DateTime.now(),
      );
    });
    _persistWords();
    _message('Çalışman kaydedildi.');
  }

  void _changeStage(String id, WordStage stage) {
    final index = _words.indexWhere((word) => word.id == id);
    if (index < 0) return;
    setState(() => _words[index] = _words[index].copyWith(stage: stage));
    _persistWords();
    _message('Öğrenme aşaması güncellendi.');
  }

  void _deleteWord(String id) {
    final index = _words.indexWhere((word) => word.id == id);
    if (index < 0) return;
    final removed = _words[index];
    setState(() => _words.removeAt(index));
    _persistWords();
    _message('“${removed.word}” silindi.');
  }

  void _setGoal(int goal) {
    setState(() => _dailyGoal = goal);
    widget.repository.saveDailyGoal(goal).catchError((Object _) => _message('Hedef kaydedilemedi.'));
    _message('Günlük hedefin: $goal kelime.');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final wide = screenWidth >= 940;
    final screens = <Widget>[
      DashboardScreen(
        words: _words,
        dailyGoal: _dailyGoal,
        onAdd: () => _selectTab(2),
        onLibrary: () => _selectTab(1),
        onReview: _reviewWord,
        onChangeGoal: _setGoal,
      ),
      DictionaryScreen(
        words: _words,
        onReview: _reviewWord,
        onMarkMastered: (id) => _changeStage(id, WordStage.mastered),
        onReset: (id) => _changeStage(id, WordStage.newWord),
        onDelete: _deleteWord,
        onAdd: () => _selectTab(2),
      ),
      AddWordScreen(key: ValueKey(_formVersion), onSubmit: _addWord),
    ];
    return Scaffold(
      appBar: wide ? null : AppBar(
        toolbarHeight: 70,
        titleSpacing: 17,
        title: const Row(children: [
          BrandMark(size: 38),
          SizedBox(width: 10),
          Text('Dil Rotası', style: TextStyle(fontFamily: 'serif', fontSize: 23, fontWeight: FontWeight.bold)),
        ]),
        actions: [
          IconButton(
            tooltip: 'Hakkında',
            onPressed: () => _about(context),
            icon: const Icon(Icons.info_outline_rounded, size: 21),
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              top: wide,
              bottom: false,
              child: Row(children: [
                if (wide)
                  SizedBox(
                    width: screenWidth >= 1180 ? 250 : 208,
                    child: _DeskSidebar(selected: _currentTab, onSelect: _selectTab, onAbout: () => _about(context)),
                  ),
                Expanded(child: Column(children: [
                  if (_loadWarning != null)
                    MaterialBanner(
                      leading: const Icon(Icons.warning_amber_rounded),
                      content: Text(_loadWarning!),
                      actions: [TextButton(onPressed: () => setState(() => _loadWarning = null), child: const Text('Kapat'))],
                    ),
                  Expanded(child: IndexedStack(index: _currentTab, children: screens)),
                ])),
              ]),
            ),
      bottomNavigationBar: wide || _loading ? null : NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Başlangıç'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'Defterim'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline_rounded), selectedIcon: Icon(Icons.add_circle_rounded), label: 'Kelime ekle'),
        ],
      ),
    );
  }

  void _about(BuildContext context) => showAboutDialog(
    context: context,
    applicationName: 'Dil Rotası | Kelime Atölyesi',
    applicationVersion: '2.0.0',
    applicationLegalese: 'Flutter ile hazırlanmış üç ekranlı eğitim projesi.',
    children: [const Text('Kelimeler yalnızca bu cihazda kaydedilir. Hesap, takip veya otomatik eşitleme bulunmaz.')],
  );
}

class _DeskSidebar extends StatelessWidget {
  const _DeskSidebar({required this.selected, required this.onSelect, required this.onAbout});
  final int selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(color: Palette.forestDeep, border: Border(right: BorderSide(color: Palette.forest))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(22, 28, 14, 32),
        child: Row(children: [
          BrandMark(size: 42),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Dil Rotası', style: TextStyle(color: Palette.paper, fontFamily: 'serif', fontWeight: FontWeight.bold, fontSize: 23)),
            Text('KELİME ATÖLYESİ', style: TextStyle(color: Palette.olive, fontSize: 9, letterSpacing: 1.3, fontWeight: FontWeight.bold)),
          ])),
        ]),
      ),
      const Padding(padding: EdgeInsets.only(left: 23, bottom: 13), child: Kicker('ÇALIŞMA MASASI', dark: true)),
      _NavItem(index: 0, selected: selected, icon: Icons.space_dashboard_outlined, label: 'Başlangıç', onSelect: onSelect),
      _NavItem(index: 1, selected: selected, icon: Icons.book_outlined, label: 'Kelime defterim', onSelect: onSelect),
      _NavItem(index: 2, selected: selected, icon: Icons.edit_note_rounded, label: 'Kelime ekle', onSelect: onSelect),
      const Spacer(),
      const Padding(padding: EdgeInsets.fromLTRB(22, 8, 22, 13), child: Divider(color: Color(0xFF4A6055))),
      TextButton.icon(
        onPressed: onAbout,
        icon: const Icon(Icons.info_outline_rounded, color: Palette.olive, size: 17),
        label: const Text('Uygulama hakkında', style: TextStyle(color: Palette.paper)),
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12)),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(22, 6, 22, 25),
        child: Text('DİL ROTASI   /   02.00\nHer kelime bir iz bırakır.', style: TextStyle(fontSize: 10, height: 1.8, letterSpacing: 1, color: Color(0xFFA8BAA7))),
      ),
    ]),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.index, required this.selected, required this.icon, required this.label, required this.onSelect});
  final int index;
  final int selected;
  final IconData icon;
  final String label;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final active = index == selected;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      child: Material(
        color: active ? const Color(0xFF3B5547) : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: () => onSelect(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(children: [
              Icon(icon, color: active ? Palette.mustard : Palette.olive, size: 21),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: TextStyle(color: Palette.paper, fontWeight: active ? FontWeight.w800 : FontWeight.w500, fontSize: 13))),
              if (active) const Icon(Icons.circle, size: 6, color: Palette.mustard),
            ]),
          ),
        ),
      ),
    );
  }
}
