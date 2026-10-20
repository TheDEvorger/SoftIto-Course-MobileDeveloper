import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/demo/demo_clinic_store.dart';
import '../../../data/models/collection_visit.dart';
import '../controllers/patient_intake_controller.dart';
import '../widgets/department_selector.dart';

/// Yeni kurgusal hasta kabulü. Başarılı kayıtta oluşan ziyareti
/// `Navigator.pop` ile önceki ekrana döndürür.
class PatientIntakeView extends StatefulWidget {
  const PatientIntakeView({super.key, required this.store});

  final DemoClinicStore store;

  /// Formu açar; kayıt yapılırsa oluşan ziyareti döner.
  static Future<CollectionVisit?> open(
      BuildContext context, DemoClinicStore store) {
    return Navigator.of(context).push<CollectionVisit>(
      MaterialPageRoute<CollectionVisit>(
        builder: (_) => PatientIntakeView(store: store),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<PatientIntakeView> createState() => _PatientIntakeViewState();
}

class _PatientIntakeViewState extends State<PatientIntakeView> {
  late final PatientIntakeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PatientIntakeController(widget.store);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final CollectionVisit? visit = _controller.submit();
    if (visit != null) Navigator.of(context).pop(visit);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _controller.appointment.value ?? TimeOfDay.now(),
      helpText: 'Randevu saati seçin',
      cancelText: 'Vazgeç',
      confirmText: 'Tamam',
      hourLabelText: 'Saat',
      minuteLabelText: 'Dakika',
      builder: (BuildContext context, Widget? child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) _controller.setAppointment(picked);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Hasta Kabulü'),
        leading: IconButton(
          tooltip: 'Kapat',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PageFrame(
        maxWidth: 680,
        child: Form(
          key: _controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: <Widget>[
              _QueuePreview(store: widget.store),
              const SizedBox(height: 16),
              const InfoBanner(
                icon: Icons.privacy_tip_outlined,
                title: 'Yalnızca kurgusal veri girin',
                message: 'TC kimlik no, adres, telefon, tahlil sonucu veya '
                    'herhangi bir sağlık bilgisi GİRMEYİN. Bu bir eğitim demosudur.',
              ),
              const SizedBox(height: 24),
              _Label('Kurgusal hasta adı'),
              TextFormField(
                key: const Key('intake_name'),
                controller: _controller.nameCtrl,
                validator: _controller.validateName,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Ör. Deniz Yıldırım',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 16),
              _Label('Demo hasta kodu'),
              TextFormField(
                key: const Key('intake_code'),
                controller: _controller.codeCtrl,
                validator: _controller.validateCode,
                textCapitalization: TextCapitalization.characters,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge_outlined),
                  helperText: 'Otomatik önerilir; gerçek kimlik numarası değildir.',
                  suffixIcon: IconButton(
                    tooltip: 'Yeni kod öner',
                    onPressed: _controller.regenerateCode,
                    icon: const Icon(Icons.autorenew_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _Label('Hizmet / birim'),
              DepartmentSelector(
                selected: _controller.department,
                onSelected: _controller.selectDepartment,
                validator: _controller.validateDepartment,
              ),
              const SizedBox(height: 20),
              _Label('Randevu saati (opsiyonel)'),
              _AppointmentPicker(
                appointment: _controller.appointment,
                onPick: _pickTime,
                onClear: () => _controller.setAppointment(null),
              ),
              const SizedBox(height: 16),
              _Label('Not (opsiyonel)'),
              TextFormField(
                controller: _controller.noteCtrl,
                validator: _controller.validateNote,
                maxLength: PatientIntakeController.noteMaxLength,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Ör. Tekerlekli sandalye ile geldi',
                  prefixIcon: Icon(Icons.sticky_note_2_outlined),
                ),
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _controller.submitError,
                builder: (BuildContext context, String? error, _) {
                  if (error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(error,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.error)),
                  );
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('intake_submit'),
                onPressed: _submit,
                icon: const Icon(Icons.how_to_reg_rounded),
                label: const Text('Kaydet ve Sıraya Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

/// Atanacak sıra numarasını canlı gösterir.
class _QueuePreview extends StatelessWidget {
  const _QueuePreview({required this.store});

  final DemoClinicStore store;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ValueListenableBuilder<ClinicState>(
      valueListenable: store.state,
      builder: (BuildContext context, ClinicState state, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                QueueBadge(
                  label: Formatters.queueNumber(state.nextQueueNumber),
                  large: true,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Atanacak sıra numarası',
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        'Numaralar gün içinde tekrar kullanılmaz.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppointmentPicker extends StatelessWidget {
  const _AppointmentPicker({
    required this.appointment,
    required this.onPick,
    required this.onClear,
  });

  final ValueNotifier<TimeOfDay?> appointment;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TimeOfDay?>(
      valueListenable: appointment,
      builder: (BuildContext context, TimeOfDay? time, _) {
        final String text = time == null
            ? 'Saat seçilmedi'
            : '${time.hour.toString().padLeft(2, '0')}:'
                '${time.minute.toString().padLeft(2, '0')}';
        return Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: onPick,
                icon: const Icon(Icons.schedule_rounded),
                label: Text(text),
              ),
            ),
            if (time != null) ...<Widget>[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Randevu saatini temizle',
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ],
        );
      },
    );
  }
}
