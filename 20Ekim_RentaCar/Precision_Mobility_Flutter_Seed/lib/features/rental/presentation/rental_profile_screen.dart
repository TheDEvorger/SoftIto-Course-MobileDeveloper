import 'package:flutter/material.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../application/rental_controller.dart';
import 'rental_actions.dart';

class RentalProfileScreen extends StatelessWidget {
  const RentalProfileScreen(
      {super.key,
      required this.controller,
      required this.onPlans,
      required this.onFavorites});
  final RentalController controller;
  final VoidCallback onPlans, onFavorites;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final data = controller.repository.data;
        final enabled = controller.ready && !controller.busy;
        return StudioPage(width: 1080, children: [
          const PageHeading(
              eyebrow: 'Size özel',
              title: 'İyi yolculuklar.',
              description:
                  'Favorilerinizi, yolculuk planlarınızı ve tercihlerinizi bir arada tutun.'),
          const SizedBox(height: 28),
          StudioPanel(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Yolculuk alanınız',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: const Text('Rezervasyonlarım'),
                    subtitle: Text(
                        '${data.plans.where((r) => !r.cancelled).length} plan · ${data.plans.where((r) => r.cancelled).length} iptal kaydı'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onPlans),
                const Divider(),
                ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.favorite_border),
                    title: const Text('Favorilerim'),
                    subtitle: Text('${data.favorites.length} kaydedilen araç'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: onFavorites),
              ])),
          const SizedBox(height: 22),
          StudioPanel(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Text('Tercihleriniz',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                const Text('Görünüm'),
                const SizedBox(height: 12),
                Wrap(spacing: 10, runSpacing: 10, children: [
                  for (final theme in [
                    ('system', 'Sistem', Icons.brightness_auto_outlined),
                    ('light', 'Açık', Icons.light_mode_outlined),
                    ('dark', 'Koyu', Icons.dark_mode_outlined)
                  ])
                    ChoiceChip(
                        label: Text(theme.$2),
                        avatar: Icon(theme.$3, size: 17),
                        selected: data.theme == theme.$1,
                        onSelected: !enabled
                            ? null
                            : (_) => rentalAction(context,
                                () => controller.preferences(theme: theme.$1))),
                ]),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                    key: ValueKey(data.city),
                    initialValue: data.city,
                    isExpanded: true,
                    decoration:
                        const InputDecoration(labelText: 'Tercih edilen şehir'),
                    items: [
                      for (final city in [
                        'Tüm şehirler',
                        'İstanbul',
                        'Ankara',
                        'İzmir'
                      ])
                        DropdownMenuItem(value: city, child: Text(city))
                    ],
                    onChanged: !enabled
                        ? null
                        : (city) => rentalAction(
                            context, () => controller.preferences(city: city))),
                const SizedBox(height: 14),
                const Text('Tercihleriniz bu cihazda hatırlanır.',
                    style: TextStyle(fontSize: 12)),
              ])),
          const SizedBox(height: 22),
          const StudioPanel(
              padding: 12,
              child: Column(children: [
                ExpansionTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('Rezervasyon nasıl çalışır?'),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                              'Keşfet bölümünden bir araç seçin. 1–7 günlük tarih aralığını ve '
                              'fiyat özetini kontrol edip rezervasyonu kaydedin. Planlarım bölümünden ayrıntılarını görebilir, '
                              'özetini kopyalayabilir veya iptal edebilirsiniz. Dönüş günü kiralama ücretine dahil değildir.'))
                    ]),
                ExpansionTile(
                    leading: Icon(Icons.phone_iphone_outlined),
                    title: Text('Verilerim nerede?'),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                              'Favorileriniz, rezervasyonlarınız ve tercihleriniz bu cihazda saklanır. '
                              'Ayrı sunucu, anahtar veya oturum açma gerekmez. Tarayıcı verilerini silmek yerel kayıtları kaldırır; '
                              'farklı bir tarayıcı adresi veya cihaz kendi kayıtlarını kullanır. Kart, kimlik belgesi veya konum toplanmaz.'))
                    ]),
                ExpansionTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Koleksiyon ve kiralama hakkında'),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                              'Bu sürümde araç bilgileri ve fiyatlar hazır örnek koleksiyondur; '
                              'görseller yapay zekâ ile üretilmiş temsilî görsellerdir. Rezervasyonlar cihazda bir yolculuk planı oluşturur. '
                              'Gerçek tedarikçiye iletim, ödeme, sürücü doğrulaması veya araç teslim onayı yapılmaz.'))
                    ]),
              ])),
          const SizedBox(height: 24),
          TextButton(
              onPressed: () => showLicensePage(
                  context: context,
                  applicationName: 'Precision',
                  applicationVersion: '0.1.0'),
              child: const Text('Açık kaynak lisansları')),
          const Text('PRECISION · YENİ ROTALAR SİZİ BEKLİYOR.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, letterSpacing: 1.2)),
        ]);
      });
}
