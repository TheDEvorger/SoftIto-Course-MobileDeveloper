import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/state/realm_controller.dart';
import '../../core/widgets/realm_card.dart';
import '../habits/habits_screen.dart';
import '../pacts/pacts_screen.dart';
import '../plaza/plaza_screen.dart';
import '../guide/guide_screen.dart';
import '../chronicle/chronicle_screen.dart';

class RealmShell extends StatefulWidget {
  const RealmShell({super.key, required this.controller});
  final RealmController controller;
  @override
  State<RealmShell> createState() => _RealmShellState();
}

class _RealmShellState extends State<RealmShell> {
  int selected = 0;
  int lastEvent = 0;
  String? burstMessage;
  Timer? _heraldTimer;
  int _heraldIndex = 0;
  static const _tips = [
    'Bir küçük adım, üç kâtip ve bir ferman kadar değerlidir.',
    'Ahitlerin seni bekliyor. Hükümdarlar da takvim kullanır.',
    'Bugün çok mu yoğun? Vazifeyi küçültmek de bir stratejidir.',
  ];
  String _heraldText(RealmController c) => _heraldIndex % 4 == 0
      ? c.herald
      : _tips[(_heraldIndex - 1) % _tips.length];

  static const labels = ['Vazifeler', 'Ahitler', 'Meydan', 'Rehber', 'Kronik'];
  static const icons = [
    Icons.task_alt,
    Icons.history_edu,
    Icons.local_florist,
    Icons.auto_awesome,
    Icons.auto_stories
  ];

  @override
  void initState() {
    super.initState();
    lastEvent = widget.controller.eventNumber;
    widget.controller.addListener(_onRealmEvent);
    _heraldTimer = Timer.periodic(const Duration(seconds: 18), (_) {
      if (mounted) setState(() => _heraldIndex++);
    });
  }

  void _onRealmEvent() {
    final c = widget.controller;
    if (!mounted || c.eventNumber == lastEvent) return;
    lastEvent = c.eventNumber;
    setState(() => _heraldIndex = 0);
    if (c.celebration == null) return;
    setState(() => burstMessage = c.celebration);
    final captured = lastEvent;
    Future<void>.delayed(const Duration(milliseconds: 1900), () {
      if (mounted && captured == lastEvent) setState(() => burstMessage = null);
    });
  }

  @override
  void dispose() {
    _heraldTimer?.cancel();
    widget.controller.removeListener(_onRealmEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final c = widget.controller;
          final accent = c.era.primary;
          return Scaffold(
            body: SafeArea(
                child: Stack(children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('HægæRûetn',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: accent,
                                  letterSpacing: -1)),
                          Text('Ałek’ryŧhæ • ${c.era.name} Çağı',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF82796C))),
                        ])),
                    RealmPill(
                        label: 'SV. ${c.level}',
                        icon: Icons.shield_outlined,
                        color: c.era.secondary),
                    const SizedBox(width: 8),
                    CircleAvatar(
                        backgroundColor: c.era.accent.withValues(alpha: .25),
                        child:
                            Icon(Icons.emoji_events_outlined, color: accent)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 7, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF0D0),
                        border: Border.all(color: const Color(0xFFE6D49F)),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(children: [
                      Icon(Icons.campaign_outlined, color: accent, size: 24),
                      const SizedBox(width: 9),
                      Expanded(
                          child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(_heraldText(c),
                            key: ValueKey<String>(_heraldText(c)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                height: 1.32,
                                fontWeight: FontWeight.w600)),
                      )),
                      const Icon(Icons.auto_awesome,
                          size: 15, color: Color(0xFFB28C47)),
                    ]),
                  ),
                ),
                Expanded(
                    child: IndexedStack(index: selected, children: [
                  HabitsScreen(controller: c),
                  PactsScreen(controller: c),
                  PlazaScreen(controller: c),
                  const GuideScreen(),
                  ChronicleScreen(controller: c),
                ])),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(top: BorderSide(color: Color(0xFFEAE5D8)))),
                  padding: const EdgeInsets.fromLTRB(6, 7, 6, 6),
                  child: Row(
                      children: List.generate(
                          5,
                          (i) => Expanded(
                                  child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => setState(() => selected = i),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: i == 2 ? 9 : 11),
                                  decoration: BoxDecoration(
                                    color: selected == i
                                        ? (i == 2
                                            ? c.era.accent
                                                .withValues(alpha: .32)
                                            : c.era.secondary
                                                .withValues(alpha: .7))
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(icons[i],
                                            color: selected == i
                                                ? accent
                                                : const Color(0xFF8D928E),
                                            size: i == 2 ? 27 : 23),
                                        const SizedBox(height: 3),
                                        Text(labels[i],
                                            style: TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: selected == i
                                                    ? FontWeight.w900
                                                    : FontWeight.w600,
                                                color: selected == i
                                                    ? accent
                                                    : const Color(0xFF777C79))),
                                      ]),
                                ),
                              )))),
                ),
              ]),
              if (burstMessage != null)
                Positioned.fill(
                    child: GestureDetector(
                        onTap: () => setState(() => burstMessage = null),
                        child: Container(
                          color: const Color(0xFF173832).withValues(alpha: .34),
                          alignment: Alignment.center,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: .45, end: 1),
                            duration: const Duration(milliseconds: 480),
                            curve: Curves.elasticOut,
                            builder: (context, scale, child) =>
                                Transform.scale(scale: scale, child: child),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7DF),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                      color: c.era.accent, width: 3)),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome,
                                        color: c.era.primary, size: 65),
                                    const SizedBox(height: 14),
                                    Text('FERMAN!',
                                        style: TextStyle(
                                            color: c.era.primary,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 28)),
                                    const SizedBox(height: 10),
                                    Text(burstMessage!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 12),
                                    const Text('Dokun ve sefere devam et',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54)),
                                  ]),
                            ),
                          ),
                        ))),
            ])),
          );
        },
      );
}
