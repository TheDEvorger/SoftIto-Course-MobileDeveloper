import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../../discovery/application/catalog_controller.dart';
import '../../discovery/domain/vehicle.dart';

class VehicleEditorScreen extends StatefulWidget {
  const VehicleEditorScreen(
      {super.key, required this.controller, this.vehicle});
  final CatalogController controller;
  final Vehicle? vehicle;
  @override
  State<VehicleEditorScreen> createState() => _VehicleEditorScreenState();
}

class _VehicleEditorScreenState extends State<VehicleEditorScreen> {
  final _form = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _fields;
  late String _ownership, _status;
  late int _seats;
  bool _saving = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _fields = {
      'name': TextEditingController(text: v?.name),
      'category': TextEditingController(text: v?.category),
      'energy': TextEditingController(text: v?.energy),
      'description': TextEditingController(text: v?.description),
      'photo_url': TextEditingController(text: v?.photoUrl),
      'rate': TextEditingController(
          text: v == null
              ? ''
              : '${v.rateMinor ~/ 100}.${(v.rateMinor % 100).toString().padLeft(2, '0')}'),
    };
    _ownership = v?.ownership ?? 'private';
    _status = v?.status ?? 'active';
    _seats = v?.seats ?? 5;
  }

  @override
  void dispose() {
    for (final field in _fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  int? _rate(String raw) {
    final value = raw.trim().replaceAll(',', '.');
    if (!RegExp(r'^\d{1,7}(\.\d{1,2})?$').hasMatch(value)) return null;
    final parts = value.split('.');
    final result = int.parse(parts.first) * 100 +
        (parts.length == 1 ? 0 : int.parse(parts.last.padRight(2, '0')));
    return result > 0 && result <= 100000000 ? result : null;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.controller.save({
        for (final key in [
          'name',
          'category',
          'energy',
          'description',
          'photo_url'
        ])
          key: _fields[key]!.text.trim(),
        'rate_minor': _rate(_fields['rate']!.text),
        'seats': _seats,
        'ownership': _ownership,
        'status': _status,
      }, id: widget.vehicle?.id);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        setState(() => _error =
            error is ApiException ? error.message : 'Araç kaydedilemedi.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _text(String key, String label, {int max = 120, int lines = 1}) =>
      TextFormField(
          controller: _fields[key],
          enabled: !_saving,
          maxLength: max,
          maxLines: lines,
          decoration: InputDecoration(labelText: label),
          validator: (v) =>
              v == null || v.trim().isEmpty ? '$label gerekli.' : null);

  Widget _pair(Widget a, Widget b) => LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth > 650 &&
              MediaQuery.textScalerOf(context).scale(1) < 1.4
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: a),
              const SizedBox(width: 20),
              Expanded(child: b)
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [a, const SizedBox(height: 16), b]));

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: !_saving,
      child: Scaffold(
          appBar: AppBar(
              title:
                  Text(widget.vehicle == null ? 'Yeni araç' : 'Araç düzenle')),
          bottomNavigationBar: SafeArea(
              top: false,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      heightFactor: 1,
                      child: SizedBox(
                          width: 600,
                          child: FilledButton.icon(
                              onPressed: _saving ? null : _save,
                              icon: const Icon(Icons.check, size: 18),
                              label: Text(_saving
                                  ? 'Kaydediliyor…'
                                  : 'Aracı kaydet')))))),
          body: Form(
              key: _form,
              child: StudioPage(width: 1060, children: [
                PageHeading(
                    eyebrow: 'Koleksiyon / Araç bilgileri',
                    title: widget.vehicle == null
                        ? 'Aracınızı tanıyalım.'
                        : 'Her detay yerli yerinde.',
                    description:
                        'Bilgileri kaydedin. Yayındaki araçlar keşif koleksiyonuna eklensin.'),
                const SizedBox(height: 30),
                if (_error != null)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Semantics(
                          liveRegion: true,
                          child: Text(_error!,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.error)))),
                StudioPanel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      Text('01 / Aracın kimliği',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 24),
                      _text('name', 'Araç adı'),
                      const SizedBox(height: 16),
                      _pair(_text('category', 'Kategori'),
                          _text('energy', 'Enerji türü')),
                      const SizedBox(height: 16),
                      _text('description', 'Açıklama', max: 1200, lines: 3),
                    ])),
                const SizedBox(height: 20),
                StudioPanel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      Text('02 / Kiralama ve yayın',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 24),
                      _pair(
                          TextFormField(
                              controller: _fields['rate'],
                              enabled: !_saving,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                  labelText: 'Günlük ücret (TRY)',
                                  prefixIcon: Icon(Icons.payments_outlined)),
                              validator: (v) => _rate(v ?? '') == null
                                  ? 'Pozitif bir ücret girin; en fazla iki ondalık basamak.'
                                  : null),
                          DropdownButtonFormField<int>(
                              initialValue: _seats,
                              decoration: const InputDecoration(
                                  labelText: 'Koltuk sayısı'),
                              items: List.generate(
                                  9,
                                  (i) => DropdownMenuItem(
                                      value: i + 1,
                                      child: Text('${i + 1} koltuk'))),
                              onChanged: _saving
                                  ? null
                                  : (v) => setState(() => _seats = v!))),
                      const SizedBox(height: 20),
                      _pair(
                          DropdownButtonFormField<String>(
                              initialValue: _ownership,
                              decoration: const InputDecoration(
                                  labelText: 'Araç kaynağı'),
                              items: const [
                                DropdownMenuItem(
                                    value: 'private', child: Text('Bireysel')),
                                DropdownMenuItem(
                                    value: 'fleet', child: Text('Filo'))
                              ],
                              onChanged: _saving
                                  ? null
                                  : (v) => setState(() => _ownership = v!)),
                          DropdownButtonFormField<String>(
                              initialValue: _status,
                              decoration: const InputDecoration(
                                  labelText: 'Yayın durumu'),
                              items: const [
                                DropdownMenuItem(
                                    value: 'active', child: Text('Yayında')),
                                DropdownMenuItem(
                                    value: 'maintenance',
                                    child: Text('Bakımda'))
                              ],
                              onChanged: _saving
                                  ? null
                                  : (v) => setState(() => _status = v!))),
                    ])),
                const SizedBox(height: 20),
                StudioPanel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      Text('03 / Aracınızın fotoğrafı',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      const Text(
                          'Varsa aracınıza ait HTTPS fotoğraf adresini ekleyin. Fotoğraf olmadan da kaydedebilirsiniz.'),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: _fields['photo_url'],
                          enabled: !_saving,
                          maxLength: 2048,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                              labelText: 'Fotoğraf adresi',
                              prefixIcon: Icon(Icons.image_outlined)),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return null;
                            final url = Uri.tryParse(v.trim());
                            return url == null ||
                                    url.scheme != 'https' ||
                                    url.host.isEmpty ||
                                    url.userInfo.isNotEmpty
                                ? 'Geçerli bir HTTPS adresi girin.'
                                : null;
                          }),
                    ])),
              ]))));
}
