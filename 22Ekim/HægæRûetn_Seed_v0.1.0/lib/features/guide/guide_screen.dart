import 'package:flutter/material.dart';
import '../../core/services/guide_service.dart';
import '../../core/widgets/realm_card.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});
  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final input = TextEditingController();
  final guide = OfflineGuideService();
  GuideTone tone = GuideTone.companion;
  final messages = <({bool user, String text})>[
    (user: false, text: 'Hoş geldin yolcu. Bir hedef seç, birlikte ilk küçük adımı bulalım.'),
  ];
  @override
  void dispose() { input.dispose(); super.dispose(); }

  void send() {
    final question = input.text.trim();
    if (question.isEmpty) return;
    setState(() {
      messages.add((user: true, text: question));
      messages.add((user: false, text: guide.reply(question, tone)));
      input.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 10), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Bilge Rehber', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 7),
        const RealmPill(label: 'Çevrimdışı prototip • gerçek yapay zekâ bağlı değil', icon: Icons.info_outline, color: Color(0xFFFFE9C6)),
        const SizedBox(height: 10),
        Wrap(spacing: 7, children: [
          ChoiceChip(label: const Text('Komutan'), selected: tone == GuideTone.commander, onSelected: (_) => setState(() => tone = GuideTone.commander)),
          ChoiceChip(label: const Text('Bilge'), selected: tone == GuideTone.sage, onSelected: (_) => setState(() => tone = GuideTone.sage)),
          ChoiceChip(label: const Text('Yoldaş'), selected: tone == GuideTone.companion, onSelected: (_) => setState(() => tone = GuideTone.companion)),
        ]),
      ],
    )),
    Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(16, 3, 16, 8), children: [
      ...messages.map((message) => Align(
        alignment: message.user ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 325),
          child: Padding(padding: const EdgeInsets.only(bottom: 9), child: RealmCard(
            color: message.user ? const Color(0xFFDCEEEB) : Colors.white,
            padding: const EdgeInsets.all(13), child: Text(message.text),
          ))),
      )),
      const Text('Yanıtlar cihaz içinde hazır kurallarla oluşturulur. Henüz uzak servise veri gönderilmez.',
        style: TextStyle(fontSize: 10, color: Colors.black54)),
    ])),
    Padding(padding: const EdgeInsets.fromLTRB(12, 4, 12, 10), child: Row(children: [
      Expanded(child: TextField(controller: input, minLines: 1, maxLines: 3,
        onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'Bugün neyi aşmak istiyorsun?', contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 10)))),
      const SizedBox(width: 7),
      IconButton.filled(onPressed: send, icon: const Icon(Icons.arrow_upward), tooltip: 'Mesajı gönder'),
    ])),
  ]);
}
