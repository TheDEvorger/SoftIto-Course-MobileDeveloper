import 'package:flutter/material.dart';

import '../../../data/demo/demo_clinic_store.dart';
import '../../../data/models/collection_visit.dart';

/// Hasta kabul formunun durumu, doğrulaması ve gönderimi.
///
/// View'ın `initState` metodunda oluşturulur, `dispose` metodunda kapatılır.
class PatientIntakeController {
  PatientIntakeController(this.store)
      : codeCtrl = TextEditingController(text: store.suggestPatientCode());

  final DemoClinicStore store;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController codeCtrl;
  final TextEditingController noteCtrl = TextEditingController();

  final ValueNotifier<String?> department = ValueNotifier<String?>(null);
  final ValueNotifier<TimeOfDay?> appointment = ValueNotifier<TimeOfDay?>(null);

  /// Form gönderimi sırasında oluşan genel hata mesajı.
  final ValueNotifier<String?> submitError = ValueNotifier<String?>(null);

  static const int noteMaxLength = 120;
  static final RegExp _nameRegExp =
      RegExp(r"^[a-zA-ZçÇğĞıİöÖşŞüÜâÂîÎûÛ\s.'-]+$");
  static final RegExp _codeRegExp = RegExp(r'^[A-Z0-9-]{3,16}$');

  // --- Doğrulayıcılar -------------------------------------------------------

  String? validateName(String? value) {
    final String v = value?.trim() ?? '';
    if (v.isEmpty) return 'Kurgusal hasta adı zorunludur.';
    if (v.length < 3) return 'En az 3 karakter girin.';
    if (!_nameRegExp.hasMatch(v)) return 'Yalnızca harf ve boşluk kullanın.';
    return null;
  }

  String? validateCode(String? value) {
    final String v = value?.trim().toUpperCase() ?? '';
    if (v.isEmpty) return 'Demo hasta kodu zorunludur.';
    if (!_codeRegExp.hasMatch(v)) {
      return '3-16 karakter; harf, rakam ve "-" kullanın.';
    }
    if (store.isPatientCodeTaken(v)) return 'Bu kod zaten kayıtlı.';
    return null;
  }

  String? validateDepartment() =>
      department.value == null ? 'Lütfen bir hizmet / birim seçin.' : null;

  String? validateNote(String? value) {
    if ((value?.trim().length ?? 0) > noteMaxLength) {
      return 'Not en fazla $noteMaxLength karakter olabilir.';
    }
    return null;
  }

  // --- Aksiyonlar -----------------------------------------------------------

  void selectDepartment(String value) => department.value = value;

  void setAppointment(TimeOfDay? time) => appointment.value = time;

  void regenerateCode() => codeCtrl.text = store.suggestPatientCode();

  void clear() {
    nameCtrl.clear();
    codeCtrl.text = store.suggestPatientCode();
    noteCtrl.clear();
    department.value = null;
    appointment.value = null;
    submitError.value = null;
  }

  /// Form geçerliyse hastayı kaydeder ve oluşan ziyareti döner.
  CollectionVisit? submit() {
    submitError.value = null;
    final bool valid = formKey.currentState?.validate() ?? false;
    if (!valid) return null;

    try {
      return store.registerPatient(
        displayName: nameCtrl.text,
        code: codeCtrl.text,
        department: department.value!,
        appointmentAt: _appointmentAsDateTime(),
        note: noteCtrl.text,
      );
    } on ArgumentError catch (e) {
      submitError.value = e.message.toString();
      return null;
    }
  }

  DateTime? _appointmentAsDateTime() {
    final TimeOfDay? t = appointment.value;
    if (t == null) return null;
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    noteCtrl.dispose();
    department.dispose();
    appointment.dispose();
    submitError.dispose();
  }
}
