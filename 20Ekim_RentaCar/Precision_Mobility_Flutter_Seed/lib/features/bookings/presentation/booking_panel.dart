import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/design/action_state.dart';
import '../../../shared/design/studio_page.dart';
import '../../discovery/domain/vehicle.dart';
import '../application/reservation_controller.dart';
import '../domain/reservation.dart';
import '../domain/price_quote.dart';

class BookingPanel extends StatefulWidget {
  const BookingPanel(
      {super.key,
      required this.vehicle,
      required this.controller,
      required this.connected,
      required this.onConnect,
      required this.onReservations,
      this.initialDates});
  final Vehicle vehicle;
  final ReservationController controller;
  final bool connected;
  final VoidCallback onConnect, onReservations;
  final DateTimeRange? initialDates;
  @override
  State<BookingPanel> createState() => _BookingPanelState();
}

class _BookingPanelState extends State<BookingPanel> {
  late DateTimeRange _dates;
  String _key = ReservationController.requestKey();
  bool _saving = false;
  bool _attempted = false;
  bool _quoting = false;
  int _quoteRequest = 0;
  PriceQuote? _quote;
  String? _error;
  Reservation? _record;
  @override
  void initState() {
    super.initState();
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    _dates = widget.initialDates != null &&
            !widget.initialDates!.start.isBefore(today)
        ? widget.initialDates!
        : DateTimeRange(
            start: tomorrow, end: tomorrow.add(const Duration(days: 1)));
    if (widget.connected) _loadQuote();
  }

  Future<void> _loadQuote() async {
    final request = ++_quoteRequest;
    setState(() {
      _quoting = true;
      _quote = null;
    });
    try {
      final quote = await widget.controller
          .quote(widget.vehicle.id, _dates.start, _dates.end);
      if (mounted && request == _quoteRequest) {
        setState(() {
          _quote = quote;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted && request == _quoteRequest) {
        setState(() => _error = error.toString());
      }
    } finally {
      if (mounted && request == _quoteRequest) setState(() => _quoting = false);
    }
  }

  Future<void> _choose() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final range = await showDateRangePicker(
        context: context,
        firstDate: today,
        lastDate: today.add(const Duration(days: 365)),
        initialDateRange: _dates,
        helpText: 'Alış ve dönüş tarihleri',
        saveText: 'Seç');
    if (!mounted || range == null) return;
    if (rentalDays(range.start, range.end) < 1 ||
        rentalDays(range.start, range.end) > 7) {
      setState(() => _error = '1–7 günlük bir tarih aralığı seçin.');
      return;
    }
    setState(() {
      _dates = range;
      _key = ReservationController.requestKey();
      _attempted = false;
      _error = null;
    });
    await _loadQuote();
  }

  Future<void> _reserve() async {
    if (_quote == null) return;
    if (_quote!.expired && !_attempted) {
      await _loadQuote();
      return;
    }
    setState(() {
      _saving = true;
      _attempted = true;
      _error = null;
    });
    try {
      final record = await widget.controller.reserve(
          widget.vehicle.id, _dates.start, _dates.end,
          requestKey: _key, quoteToken: _quote!.token);
      if (mounted) setState(() => _record = record);
    } catch (error) {
      if (mounted) {
        setState(() => _error = error is ApiException
            ? error.message
            : 'Rezervasyon kaydedilemedi.');
        if (error is ApiException && error.status == 409) {
          await _loadQuote();
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.connected) {
      return ActionState(
          title: 'Yolculuğu planlamaya başlayın.',
          message:
              'Rezervasyon kaydı oluşturmak için çalışma alanınıza bağlanın.',
          icon: Icons.key_outlined,
          action: widget.onConnect,
          label: 'Çalışma alanına bağlan');
    }
    if (_record != null) {
      return ActionState(
          title: 'Rezervasyon kaydedildi',
          message:
              'Sunucuda kayıtlı toplam: ${_record!.totalLabel}\nReferans: ${_record!.id}',
          icon: Icons.check_circle_outline,
          action: widget.onReservations,
          label: 'Rezervasyonlarıma git');
    }
    final days = rentalDays(_dates.start, _dates.end);
    final dates = MaterialLocalizations.of(context);
    return PopScope(
        canPop: !_saving,
        child: StudioPanel(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Text('Sizin yolculuğunuz',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${widget.vehicle.rateLabel} / gün',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),
              Text('ALIŞ',
                  style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Text(dates.formatMediumDate(_dates.start),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 18),
              Text('DÖNÜŞ',
                  style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Text(dates.formatMediumDate(_dates.end),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                  onPressed: _saving || _quoting ? null : _choose,
                  icon: const Icon(Icons.calendar_today_outlined, size: 17),
                  label: const Text('Tarihleri değiştir')),
              const Divider(height: 36),
              Text('$days gün · Sunucu fiyat teklifi'),
              const SizedBox(height: 8),
              if (_quoting)
                const LinearProgressIndicator()
              else if (_quote != null)
                Text(_quote!.totalLabel,
                    style: Theme.of(context).textTheme.headlineMedium),
              if (_quote != null)
                Text('${_quote!.rateLabel} / gün · Teklif 5 dakika geçerli',
                    style: const TextStyle(fontSize: 12)),
              TextButton.icon(
                  onPressed: _saving || _quoting ? null : _loadQuote,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Fiyatı ve müsaitliği yenile')),
              const SizedBox(height: 16),
              const Text(
                  'Tutar ve müsaitlik sunucudan alınır, kayıt sırasında tekrar kontrol edilir. Dönüş günü kiralamaya dahil değildir. '
                  'Bu adım rezervasyon kaydı oluşturur; ödeme hizmeti henüz bağlı değildir.',
                  style: TextStyle(fontSize: 12)),
              if (_error != null)
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Semantics(
                        liveRegion: true,
                        child: Text(_error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)))),
              const SizedBox(height: 24),
              FilledButton.icon(
                  onPressed:
                      _saving || _quoting || _quote == null ? null : _reserve,
                  icon: const Icon(Icons.north_east, size: 18),
                  label: Text(
                      _saving ? 'Kaydediliyor…' : 'Rezervasyon kaydı oluştur')),
            ])));
  }
}
