import 'package:flutter/material.dart';

import '../../core/state/realm_controller.dart';
import '../../core/widgets/ornate_widgets.dart';
import '../../core/widgets/realm_card.dart';

class PlazaScreen extends StatefulWidget {
  const PlazaScreen({super.key, required this.controller});
  final RealmController controller;

  @override
  State<PlazaScreen> createState() => _PlazaScreenState();
}

class _PlazaScreenState extends State<PlazaScreen> {
  final encouragement = const [
    (
      'Gezgin Lâvren',
      'Bugün ancak beş dakika çalışabildim. Yine de defteri açmış olmak güzel.'
    ),
    (
      'Mühürdar Eril',
      'Yedi gün hedefimi tamamladım! Küçük adımlardan koca yol çıktı.'
    ),
    (
      'İzci Sylra',
      'Dün aksattım, bugün daha küçük bir hedefle yeniden başladım.'
    ),
  ];

  final messages = <String>[];
  final draft = TextEditingController();

  @override
  void dispose() {
    draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.controller.era.primary;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        FancyHeroHeader(
          title: 'Gayret Meydanı',
          subtitle:
              'Yoldaşını güçlendir; kendi yolunu da aydınlat. Yardım ettikçe erdemin artsın.',
          assetPath: ArtAssets.plaza,
          height: 185,
          badge: FramedIconBadge(
            icon: Icons.volunteer_activism_outlined,
            label: 'Erdem',
            value: '—',
            color: accent,
          ),
        ),
        const SizedBox(height: 15),
        const RealmCard(
          color: Color(0xFFFFEDCD),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.groups_2_outlined, size: 32, color: Color(0xFF9B6229)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Topluluk önizlemesi',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 17)),
                    SizedBox(height: 5),
                    Text(
                        'Bu meydandaki kişiler ve iletiler kurgusaldır. Mesajların sadece bu oturumda gösterilir, başka kullanıcılara gönderilmez. Gerçek topluluk özelliği henüz bağlı değil.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle('Meydandan sesler',
            icon: Icons.record_voice_over_rounded),
        const SizedBox(height: 9),
        ...encouragement.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: RealmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                          radius: 15, child: Icon(Icons.person, size: 16)),
                      const SizedBox(width: 9),
                      Text(entry.$1,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(entry.$2),
                  const SizedBox(height: 9),
                  const RealmPill(
                      label: 'Örnek karakter',
                      icon: Icons.theater_comedy_outlined),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        RealmCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bir destek mesajı taslağı yaz',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              TextField(
                controller: draft,
                maxLines: 3,
                maxLength: 280,
                decoration: const InputDecoration(
                    hintText: 'Örn. Küçük adım da ilerlemedir, devam!'),
              ),
              const SizedBox(height: 5),
              OrnateButton(
                label: 'Taslağı burada göster',
                icon: Icons.edit_note,
                expanded: true,
                onPressed: () {
                  if (draft.text.trim().isEmpty) return;
                  setState(() {
                    messages.insert(0, draft.text.trim());
                    draft.clear();
                  });
                },
              ),
            ],
          ),
        ),
        if (messages.isNotEmpty) ...[
          const SizedBox(height: 14),
          const SectionTitle('Bu oturumdaki taslakların',
              icon: Icons.forum_outlined),
          ...messages.map((m) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: RealmCard(child: Text(m)))),
        ],
        const SizedBox(height: 17),
        const Text(
          'Erdem rozetleri, yalnızca gerçek topluluk servisi bağlandıktan sonra doğrulanmış yardımlarla kazanılacak.',
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
