import 'package:flutter/material.dart';

import '../core/palette.dart';
import '../models/vocabulary_word.dart';
import '../widgets/ui_parts.dart';

/// Bu ekranda formun state'i local, kayıt ana uygulamaya callback ile gider.
class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key, required this.onSubmit});
  final ValueChanged<VocabularyWord> onSubmit;
  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();
  final _exampleController = TextEditingController();
  StudyLanguage _language = StudyLanguage.german;

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Bu alanı doldurmalısın.';
    if (value!.trim().length > 90) return 'En fazla 90 karakter yazabilirsin.';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(VocabularyWord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      language: _language,
      word: _wordController.text.trim(),
      meaning: _meaningController.text.trim(),
      example: _exampleController.text.trim(),
      createdAt: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: PageFrame(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Kicker('YENİ BİR SAYFA   /   03'),
        const SizedBox(height: 11),
        Text('Defterine bir\nkelime bırak.', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 11),
        const Text('Okuduğun, duyduğun ya da öğrendiğin ifadeleri burada biriktir.', style: TextStyle(color: Palette.muted, fontSize: 14)),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, constraints) {
          // İki sütun yalnızca form için 520+ ve kart için 300+ yer varsa.
          final sideBySide = constraints.maxWidth >= 920;
          final form = _formPanel();
          final preview = _previewPanel();
          if (!sideBySide) return Column(children: [form, const SizedBox(height: 18), preview]);
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 7, child: form),
            const SizedBox(width: 18),
            Expanded(flex: 5, child: preview),
          ]);
        }),
      ]),
    ),
  );

  Widget _formPanel() => SurfacePanel(
    padding: const EdgeInsets.all(23),
    child: Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Kicker('KELİME FİŞİ   •   01'),
        const SizedBox(height: 10),
        const Text('Hangi dili çalışıyoruz?', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, color: Palette.ink, fontSize: 21)),
        const SizedBox(height: 12),
        // Sabit genişlik veya SegmentedButton yok: taşarsa alt satıra geçer.
        Wrap(spacing: 9, runSpacing: 9, children: [
          for (final language in StudyLanguage.values)
            _LanguageOption(
              language: language,
              selected: _language == language,
              onTap: () => setState(() => _language = language),
            ),
        ]),
        const SizedBox(height: 27),
        const _FieldLabel('Kelime veya ifade', mandatory: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _wordController,
          maxLength: 90,
          validator: _required,
          onChanged: (_) => setState(() {}),
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Örn. die Herausforderung'),
        ),
        const SizedBox(height: 7),
        const _FieldLabel('Türkçe anlamı', mandatory: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _meaningController,
          maxLength: 90,
          validator: _required,
          onChanged: (_) => setState(() {}),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Örn. zorluk, meydan okuma'),
        ),
        const SizedBox(height: 7),
        const _FieldLabel('Örnek cümle'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _exampleController,
          maxLength: 240,
          maxLines: 3,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(hintText: 'Örn. Das ist eine große Herausforderung.'),
        ),
        const SizedBox(height: 19),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.bookmark_add_outlined, size: 20),
            label: const Text('Kelimeyi deftere kaydet'),
          ),
        ),
        const SizedBox(height: 10),
        const Row(children: [
          Icon(Icons.lock_outline_rounded, size: 16, color: Palette.moss),
          SizedBox(width: 7),
          Expanded(child: Text('Bu cihazda saklanır. Buluta gönderilmez.', style: TextStyle(color: Palette.muted, fontSize: 12))),
        ]),
      ]),
    ),
  );

  Widget _previewPanel() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Container(
      decoration: BoxDecoration(color: Palette.coralLight, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Kicker('KARTIN ÖNİZLEMESİ'),
        const SizedBox(height: 8),
        const Text('Daha kaydetmeden\nnasıl görünecek?', style: TextStyle(fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight.bold, color: Palette.ink)),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 23),
          decoration: BoxDecoration(color: Palette.paper, borderRadius: BorderRadius.circular(9), border: Border.all(color: Palette.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              LanguageBadge(language: _language),
              const Spacer(),
              const Text('01 / NOT', style: TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold, color: Palette.muted)),
            ]),
            const SizedBox(height: 27),
            Text(_wordController.text.trim().isEmpty ? 'Dein Wort…' : _wordController.text.trim(), style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, fontSize: 29, color: Palette.ink)),
            const SizedBox(height: 8),
            Text(_meaningController.text.trim().isEmpty ? 'Anlamı burada görünecek' : _meaningController.text.trim(), style: const TextStyle(color: Palette.muted, fontSize: 14)),
            if (_exampleController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 22),
              const Divider(),
              const SizedBox(height: 8),
              Text('“${_exampleController.text.trim()}”', style: const TextStyle(fontFamily: 'serif', fontStyle: FontStyle.italic, color: Palette.ink, fontSize: 14)),
            ],
            const SizedBox(height: 24),
            const Row(children: [
              Icon(Icons.auto_stories_outlined, size: 16, color: Palette.terracotta),
              SizedBox(width: 7),
              Text('DİL ROTASI', style: TextStyle(letterSpacing: 1.8, fontSize: 10, fontWeight: FontWeight.bold, color: Palette.terracotta)),
            ]),
          ]),
        ),
      ]),
    ),
    const SizedBox(height: 15),
    const SurfacePanel(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.lightbulb_outline_rounded, color: Palette.terracotta),
      SizedBox(width: 11),
      Expanded(child: Text('İpucu: Bir kelimenin yanına kendi örnek cümleni yazmak, onu hatırlamanı kolaylaştırabilir.', style: TextStyle(fontSize: 13, color: Palette.muted))),
    ])),
  ]);
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.language, required this.selected, required this.onTap});
  final StudyLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? Palette.forest : Palette.parchment,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: selected ? Palette.forest : Palette.border),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(language.flag, style: const TextStyle(fontSize: 17)),
          const SizedBox(width: 8),
          Text(language.label, style: TextStyle(color: selected ? Palette.paper : Palette.ink, fontWeight: FontWeight.bold, fontSize: 13)),
          if (selected) ...[
            const SizedBox(width: 9),
            const Icon(Icons.check_rounded, size: 17, color: Palette.olive),
          ],
        ]),
      ),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.title, {this.mandatory = false});
  final String title;
  final bool mandatory;

  @override
  Widget build(BuildContext context) => Text.rich(TextSpan(children: [
    TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.w700, color: Palette.ink, fontSize: 13)),
    if (mandatory) const TextSpan(text: ' *', style: TextStyle(color: Palette.terracotta)),
  ]));
}
