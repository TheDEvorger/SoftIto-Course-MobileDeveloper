import 'package:flutter/material.dart';
import '../../../shared/design/studio_page.dart';
import '../application/rental_controller.dart';
import '../data/device_rental_repository.dart';
import '../domain/local_reservation.dart';
import '../domain/rental_vehicle.dart';
import 'rental_actions.dart';

class LocalBookingPanel extends StatefulWidget {
  const LocalBookingPanel(
      {super.key,
      required this.controller,
      required this.vehicle,
      required this.onReservations,
      this.initialDates});
  final RentalController controller;
  final RentalVehicle vehicle;
  final DateTimeRange? initialDates;
  final VoidCallback onReservations;
  @override
  State<LocalBookingPanel> createState() => _LocalBookingPanelState();
}

class _LocalBookingPanelState extends State<LocalBookingPanel> {
  late DateTimeRange _dates;
  RentalQuote? _quote;
  LocalReservation? _record;
  String? _error;
  bool _saving = false;
  String _request = DeviceRentalRepository.newRequestKey();
  @override
  void initState() {
    super.initState();
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    _dates = widget.initialDates != null &&
            !widget.initialDates!.start.isBefore(today)
        ? widget.initialDates!
        : DateTimeRange(
            start: tomorrow,
            end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day + 2));
    _calculate();
  }

  void _calculate() {
    try {
      _quote = widget.controller.repository
          .quote(widget.vehicle.id, _dates.start, _dates.end);
      _error = null;
    } catch (error) {
      _quote = null;
      _error = error.toString();
    }
  }

  Future<void> _choose() async {
    final dates = await rentalDates(context, initial: _dates);
    if (dates == null || !mounted) return;
    setState(() {
      _dates = dates;
      _request = DeviceRentalRepository.newRequestKey();
      _calculate();
    });
  }

  Future<void> _book() async {
    if (_quote == null || _saving) return;
    setState(() => _saving = true);
    final quote = _quote!;
    final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                scrollable: true,
                title: const Text('Yolculuk planını onaylayın'),
                content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.vehicle.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text('${quote.days} gün · ${quote.totalLabel}'),
                      const SizedBox(height: 16),
                      const Text(
                          'Bu rezervasyon cihazınıza kaydedilir. Araç tedarikçisine iletilmez ve ödeme alınmaz.'),
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Vazgeç')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Rezervasyonu kaydet'))
                ]));
    if (!mounted) return;
    if (accepted != true) {
      setState(() => _saving = false);
      return;
    }
    try {
      final record = await widget.controller.reserve(quote, _request);
      if (mounted) {
        setState(() {
          _record = record;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _calculate();
          _error = error.toString();
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dates = MaterialLocalizations.of(context);
    if (_record != null) {
      return StudioPanel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Icon(Icons.check_circle_outline,
            color: Theme.of(context).colorScheme.primary, size: 48),
        const SizedBox(height: 20),
        Text('Rezervasyonunuz kaydedildi.',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text('Referans: ${_record!.id}'),
        const SizedBox(height: 8),
        Text(
            '${dates.formatMediumDate(_record!.start)} — ${dates.formatMediumDate(_record!.end)}'),
        const SizedBox(height: 8),
        Text(_record!.totalLabel,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        const Text(
            'Bu cihazda kayıtlı. Tedarikçi onayı veya tahsilat yapılmadı.',
            style: TextStyle(fontSize: 12)),
        const SizedBox(height: 22),
        FilledButton(
            onPressed: widget.onReservations,
            child: const Text('Rezervasyonlarımı gör')),
      ]));
    }
    return PopScope(
        canPop: !_saving,
        child: StudioPanel(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Text('Yolculuğunuzu planlayın',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${widget.vehicle.dailyLabel} / gün'),
              const Divider(height: 32),
              const Text('ALIŞ TARİHİ',
                  style: TextStyle(fontSize: 10, letterSpacing: 1.2)),
              Text(dates.formatMediumDate(_dates.start),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              const Text('DÖNÜŞ TARİHİ',
                  style: TextStyle(fontSize: 10, letterSpacing: 1.2)),
              Text(dates.formatMediumDate(_dates.end),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                  onPressed: _saving ? null : _choose,
                  icon: const Icon(Icons.calendar_month_outlined, size: 18),
                  label: const Text('Tarihleri değiştir')),
              const Divider(height: 32),
              if (_quote != null) ...[
                Text('${_quote!.days} gün × ${widget.vehicle.dailyLabel}'),
                const SizedBox(height: 8),
                Text(_quote!.totalLabel,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text('Ek hizmet veya ödeme eklenmedi.',
                    style: TextStyle(fontSize: 12)),
              ],
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Semantics(
                        liveRegion: true,
                        child: Text(_error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)))),
              const SizedBox(height: 22),
              FilledButton.icon(
                  onPressed: _saving ||
                          !widget.controller.ready ||
                          widget.controller.busy ||
                          _quote == null
                      ? null
                      : _book,
                  icon: const Icon(Icons.arrow_outward, size: 18),
                  label:
                      Text(_saving ? 'Kaydediliyor…' : 'Rezervasyon oluştur')),
              const SizedBox(height: 14),
              const Text(
                  'Hazır koleksiyonun fiyat özetidir. Plan bu cihazda saklanır; '
                  'gerçek kiralama veya ödeme onayı değildir. Dönüş günü ücrete dahil değildir.',
                  style: TextStyle(fontSize: 11)),
            ])));
  }
}
