import 'package:flutter/material.dart';

import '../core/palette.dart';
import '../models/vocabulary_word.dart';
import '../widgets/ui_parts.dart';

/// Filtreleme için yerel state ve setState kullanılır.
class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({
    super.key,
    required this.words,
    required this.onReview,
    required this.onMarkMastered,
    required this.onReset,
    required this.onDelete,
    required this.onAdd,
  });
  final List<VocabularyWord> words;
  final ValueChanged<String> onReview;
  final ValueChanged<String> onMarkMastered;
  final ValueChanged<String> onReset;
  final ValueChanged<String> onDelete;
  final VoidCallback onAdd;
  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  StudyLanguage? _language;
  WordStage? _stage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() => setState(() {
    _searchController.clear();
    _query = '';
    _language = null;
    _stage = null;
  });

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final matches = widget.words.where((w) {
      return (query.isEmpty || w.word.toLowerCase().contains(query) || w.meaning.toLowerCase().contains(query) || w.example.toLowerCase().contains(query)) &&
          (_language == null || w.language == _language) &&
          (_stage == null || w.stage == _stage);
    }).toList();

    return SingleChildScrollView(
      child: PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Kicker('KİŞİSEL ARŞİV   /   02'),
          const SizedBox(height: 11),
          Text('Kelime defterim', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 11),
          const Text('Birikmiş kelimelerin, küçük bir sözlüğün. Ara, dön, tekrar et.', style: TextStyle(color: Palette.muted, fontSize: 14)),
          const SizedBox(height: 24),
          SurfacePanel(
            padding: const EdgeInsets.fromLTRB(17, 18, 17, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Kelime veya anlam ara...',
                  prefixIcon: const Icon(Icons.search_rounded, color: Palette.moss),
                  suffixIcon: query.isNotEmpty ? IconButton(
                    tooltip: 'Aramayı temizle',
                    onPressed: () => setState(() { _searchController.clear(); _query = ''; }),
                    icon: const Icon(Icons.close_rounded),
                  ) : null,
                ),
              ),
              const SizedBox(height: 17),
              const Kicker('DİL SEÇİMİ'),
              const SizedBox(height: 9),
              Wrap(spacing: 7, runSpacing: 5, children: [
                _filter('Hepsi', _language == null, () => setState(() => _language = null)),
                for (final language in StudyLanguage.values)
                  _filter('${language.flag} ${language.label}', _language == language, () => setState(() => _language = language)),
              ]),
              const SizedBox(height: 12),
              const Kicker('ÖĞRENME AŞAMASI'),
              const SizedBox(height: 9),
              Wrap(spacing: 7, runSpacing: 5, children: [
                _filter('Her aşama', _stage == null, () => setState(() => _stage = null)),
                for (final stage in WordStage.values)
                  _filter(stage.label, _stage == stage, () => setState(() => _stage = stage)),
              ]),
            ]),
          ),
          const SizedBox(height: 22),
          Row(children: [
            Expanded(child: Text('${matches.length} KELİME   /   KAYITLI ${widget.words.length}', style: const TextStyle(letterSpacing: 1.15, color: Palette.ink, fontSize: 11, fontWeight: FontWeight.w800))),
            if (query.isNotEmpty || _language != null || _stage != null)
              TextButton(onPressed: _clearFilters, child: const Text('Temizle')),
            IconButton.filledTonal(
              tooltip: 'Yeni kelime',
              onPressed: widget.onAdd,
              icon: const Icon(Icons.add_rounded),
            ),
          ]),
          const SizedBox(height: 13),
          if (matches.isEmpty)
            EmptyState(
              title: widget.words.isEmpty ? 'İlk sayfa seni bekliyor' : 'Aradığın kelimeyi bulamadım',
              message: widget.words.isEmpty ? 'Defterine ilk kelimeni ekleyebilirsin.' : 'Başka bir kelime veya filtre deneyebilirsin.',
              icon: Icons.chrome_reader_mode_outlined,
              action: widget.words.isEmpty
                  ? FilledButton.icon(onPressed: widget.onAdd, icon: const Icon(Icons.add), label: const Text('Kelime ekle'))
                  : OutlinedButton(onPressed: _clearFilters, child: const Text('Filtreleri kaldır')),
            )
          else
            LayoutBuilder(builder: (context, constraints) {
              // Her kart için >= 320dp hedeflenir: yatay kırpılma yok.
              final columns = constraints.maxWidth >= 760 ? 2 : 1;
              final cardWidth = (constraints.maxWidth - (columns == 2 ? 14 : 0)) / columns;
              return Wrap(spacing: 14, runSpacing: 14, children: [
                for (final item in matches)
                  SizedBox(width: cardWidth, child: WordTile(
                    key: ValueKey(item.id),
                    word: item,
                    onReview: () => widget.onReview(item.id),
                    onMastered: () => widget.onMarkMastered(item.id),
                    onReset: () => widget.onReset(item.id),
                    onDelete: () => _confirmDelete(context, item),
                  )),
              ]);
            }),
        ]),
      ),
    );
  }

  Widget _filter(String title, bool active, VoidCallback onTap) => ChoiceChip(
    label: Text(title),
    selected: active,
    onSelected: (_) => onTap(),
    selectedColor: Palette.sage,
    backgroundColor: Palette.parchment,
    side: BorderSide(color: active ? Palette.moss : Palette.border),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    labelStyle: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.w800 : FontWeight.w500, color: active ? Palette.forest : Palette.muted),
    visualDensity: VisualDensity.compact,
  );

  Future<void> _confirmDelete(BuildContext context, VocabularyWord word) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kelime silinsin mi?'),
        content: Text('“${word.word}” defterinden kaldırılacak.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Vazgeç')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Sil')),
        ],
      ),
    );
    if (confirmed == true && mounted) widget.onDelete(word.id);
  }
}
