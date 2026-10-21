import 'package:flutter/material.dart';

import '../../core/theme/garden_palette.dart';
import '../../domain/models/student_preferences.dart';
import '../../domain/repositories/preferences_repository.dart';
import 'garden_buttons.dart';

class PreferencesDialog extends StatefulWidget {
  const PreferencesDialog({
    required this.repository,
    this.initialPreferences,
    super.key,
  });

  final PreferencesRepository repository;
  final StudentPreferences? initialPreferences;

  static Future<StudentPreferences?> show(
    BuildContext context, {
    required PreferencesRepository repository,
    StudentPreferences? initialPreferences,
  }) {
    return showModalBottomSheet<StudentPreferences>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PreferencesDialog(
        repository: repository,
        initialPreferences: initialPreferences,
      ),
    );
  }

  @override
  State<PreferencesDialog> createState() => _PreferencesDialogState();
}

class _PreferencesDialogState extends State<PreferencesDialog> {
  late TextEditingController _nameController;
  late TextEditingController _netController;
  late String _selectedField;
  DateTime? _selectedDate;
  bool _isLoading = false;

  final _fields = const ['Sayısal', 'Eşit Ağırlık', 'Sözel', 'Dil'];

  @override
  void initState() {
    super.initState();
    final prefs = widget.initialPreferences;
    _nameController = TextEditingController(text: prefs?.displayName ?? '');
    _netController = TextEditingController(
        text: prefs?.targetNet != null ? prefs!.targetNet.toString() : '');
    _selectedField = prefs?.field ?? 'Sayısal';
    _selectedDate = prefs?.targetDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _netController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedDate ?? DateTime(now.year + 1, 6, 20, 10, 15);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          initial.isBefore(now) ? now.add(const Duration(days: 30)) : initial,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      helpText: 'Hedef Sınav Tarihini Seç',
      confirmText: 'Seç',
      cancelText: 'İptal',
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
        helpText: 'Sınav Başlama Saatini Seç',
        confirmText: 'Ayarla',
        cancelText: 'İptal',
      );

      final hour = pickedTime?.hour ?? 10;
      final minute = pickedTime?.minute ?? 15;

      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          hour,
          minute,
        );
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    final existing =
        widget.initialPreferences ?? await widget.repository.getPreferences();

    final targetNet = double.tryParse(_netController.text.trim());
    final displayName = _nameController.text.trim().isEmpty
        ? null
        : _nameController.text.trim();

    final updated = existing.copyWith(
      displayName: displayName,
      field: _selectedField,
      targetDate: _selectedDate,
      targetNet: targetNet,
    );

    await widget.repository.savePreferences(updated);
    if (mounted) {
      Navigator.of(context).pop(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? GardenPalette.nightCard : GardenPalette.sandyPorcelain;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.tune, color: GardenPalette.mossEmerald),
                const SizedBox(width: 8),
                Text(
                  'Öğrenci ve Sınav Ayarları',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFF8F2E8)
                        : GardenPalette.inkPlum,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // İsim alanı
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'İsmin veya Takma Adın (İsteğe bağlı)',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Alan seçimi
            Text(
              'YKS Alanın:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _fields.map((f) {
                final isSelected = f == _selectedField;
                return ChoiceChip(
                  label: Text(f),
                  selected: isSelected,
                  selectedColor: GardenPalette.mossEmerald,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedField = f);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Hedef Net
            TextField(
              controller: _netController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Hedeflenen Toplam Net (Örn: 95.0)',
                prefixIcon: const Icon(Icons.flag_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sınav Tarihi Ayarı
            Text(
              'Hedef YKS Tarihi (Resmî veya Tahmini):',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? GardenPalette.nightBackdrop : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: GardenPalette.mossEmerald.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month,
                      color: GardenPalette.peachCoral),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day.toString().padLeft(2, '0')}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.year} ${_selectedDate!.hour.toString().padLeft(2, '0')}:${_selectedDate!.minute.toString().padLeft(2, '0')}'
                          : 'Tarih seçilmedi (Geri sayım kapalı)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _selectedDate != null
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _selectedDate != null
                            ? (isDark
                                ? const Color(0xFFF8F2E8)
                                : GardenPalette.inkPlum)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child:
                        Text(_selectedDate != null ? 'Değiştir' : 'Tarih Seç'),
                  ),
                  if (_selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      tooltip: 'Tarihi Kaldır',
                      onPressed: () => setState(() => _selectedDate = null),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GardenPrimaryButton(
              label: 'Ayarları Kaydet',
              icon: Icons.check,
              isLoading: _isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
