import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/demo/demo_clinic_store.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';

/// Kullanıcının bir ziyaret üzerindeki niyetlerini (çağır, ilerlet, iptal)
/// işler; store'u çağırır ve geri bildirimi (SnackBar / onay) gösterir.
///
/// Dashboard, Sıra, Detay ve Numune ekranları aynı davranışı paylaşır.
class VisitActions {
  const VisitActions(this.store);

  final DemoClinicStore store;

  /// Sıradaki bekleyen hastayı çağırır.
  void callNext(BuildContext context) {
    final CollectionVisit? called = store.callNext();
    if (called == null) {
      _showMessage(context, 'Sırada bekleyen hasta yok.');
      return;
    }
    _showMessage(
      context,
      '${_label(called)} çağrıldı.',
      withUndo: true,
    );
  }

  /// Ziyareti bir sonraki adıma taşır (geri alınabilir).
  void advance(BuildContext context, CollectionVisit visit) {
    final CollectionStatus? next = visit.status.next;
    if (next == null || !store.advance(visit.id)) {
      _showMessage(context, 'Bu işlem için geçerli bir sonraki adım yok.');
      return;
    }
    _showMessage(
      context,
      '${_label(visit)} → ${next.label}',
      withUndo: true,
    );
  }

  /// Onay aldıktan sonra ziyareti iptal eder.
  Future<void> cancel(BuildContext context, CollectionVisit visit) async {
    if (!visit.status.canCancel) return;
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext ctx) => _CancelDialog(label: _label(visit)),
        ) ??
        false;
    if (!confirmed || !context.mounted) return;
    if (store.cancel(visit.id)) {
      _showMessage(context, '${_label(visit)} iptal edildi.', withUndo: true);
    }
  }

  String _label(CollectionVisit visit) {
    final DemoPatient? p = store.current.patientOf(visit);
    final String number = Formatters.queueNumber(visit.queueNumber);
    return p == null
        ? number
        : '$number · ${Formatters.shortName(p.displayName)}';
  }

  void _showMessage(BuildContext context, String text,
      {bool withUndo = false}) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          duration: const Duration(seconds: 4),
          action: withUndo
              ? SnackBarAction(
                  label: 'Geri Al',
                  onPressed: () {
                    if (store.undo()) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Son işlem geri alındı.')),
                      );
                    }
                  },
                )
              : null,
        ),
      );
  }
}

class _CancelDialog extends StatelessWidget {
  const _CancelDialog({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final Color coral = context.palette.coral;
    return AlertDialog(
      icon: Icon(Icons.cancel_outlined, color: coral, size: 32),
      title: const Text('İşlem iptal edilsin mi?'),
      content: Text(
        '$label kaydı "İptal" durumuna alınacak. '
        'Varsa ilişkili kurgusal numune de iptal edilir.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: coral,
            foregroundColor: Theme.of(context).colorScheme.surface,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('İptal Et'),
        ),
      ],
    );
  }
}
