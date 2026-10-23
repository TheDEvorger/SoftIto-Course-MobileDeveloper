import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/state/realm_controller.dart';
import '../../core/widgets/ornate_widgets.dart';
import '../chronicle/chronicle_screen.dart';
import '../guide/guide_screen.dart';
import '../habits/habits_screen.dart';
import '../pacts/pacts_screen.dart';
import '../plaza/plaza_screen.dart';

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

  static const labels = ['Vazifeler', 'Ahitler', 'Meydan', 'Rehber', 'Kronik'];
  static const icons = [
    Icons.task_alt_rounded,
    Icons.history_edu_rounded,
    Icons.local_florist_rounded,
    Icons.auto_awesome_rounded,
    Icons.auto_stories_rounded,
  ];

  String _heraldText(RealmController c) => _heraldIndex % 4 == 0
      ? c.herald
      : _tips[(_heraldIndex - 1) % _tips.length];

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
    Future<void>.delayed(const Duration(milliseconds: 2200), () {
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final c = widget.controller;
        final accent = c.era.primary;
        final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
        return Scaffold(
          body: Stack(
            children: [
              // 1. Panoramic high fantasy wallpaper
              Positioned.fill(
                child: Image.asset(
                  ArtAssets.wallpaper,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              // 2. Luminous fantasy parchment wash & atmospheric haze
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        const Color(0xFFFBF7EF).withValues(alpha: 0.85),
                        const Color(0xFFF4ECE0).withValues(alpha: 0.92),
                      ],
                      stops: const [0.0, 0.18, 1.0],
                    ),
                  ),
                ),
              ),
              // 3. Era-adaptive celestial ambient light
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 180,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.1,
                      colors: [
                        accent.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // 4. Safe area and foreground interactive UI
              SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        if (!keyboardVisible)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.workspace_premium_rounded,
                                              color: Color(0xFFD4AF37),
                                              size: 22),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              'HægæRûetn',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontSize: 26,
                                                    color: accent,
                                                    fontWeight: FontWeight.w900,
                                                    letterSpacing: -0.5,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: accent,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              'Ałek’ryŧhæ • ${c.era.name} Çağı',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF5E5445),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                FramedIconBadge(
                                  icon: Icons.shield_outlined,
                                  label: 'Seviye',
                                  value: '${c.level}',
                                  color: c.era.primary,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        c.era.accent,
                                        Color.lerp(
                                            c.era.accent, Colors.white, .3)!,
                                      ],
                                    ),
                                    border: Border.all(
                                        color: const Color(0xFFE5C368),
                                        width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4A3816)
                                            .withValues(alpha: 0.12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                      Icons.notifications_active_outlined,
                                      color: c.era.primary,
                                      size: 20),
                                ),
                              ],
                            ),
                          ),
                        if (!keyboardVisible)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 450),
                              child: HeraldBanner(
                                key: ValueKey<String>(_heraldText(c)),
                                message: _heraldText(c),
                                accent: c.era.primary,
                              ),
                            ),
                          ),
                        Expanded(
                          child: IndexedStack(
                            index: selected,
                            children: [
                              HabitsScreen(controller: c),
                              PactsScreen(controller: c),
                              PlazaScreen(controller: c),
                              GuideScreen(controller: c),
                              ChronicleScreen(controller: c),
                            ],
                          ),
                        ),
                        _BottomRealmNavigation(
                          selected: selected,
                          labels: labels,
                          icons: icons,
                          accent: c.era.primary,
                          highlight: c.era.accent,
                          onTap: (index) => setState(() => selected = index),
                        ),
                      ],
                    ),
                    if (burstMessage != null)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => setState(() => burstMessage = null),
                          child: Container(
                            color:
                                const Color(0xFF173832).withValues(alpha: .34),
                            alignment: Alignment.center,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: .45, end: 1),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.elasticOut,
                              builder: (context, scale, child) =>
                                  Transform.scale(scale: scale, child: child),
                              child: OrnateCard(
                                color: const Color(0xFFFFF7DF),
                                borderColor: c.era.accent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.auto_awesome,
                                          color: c.era.primary, size: 68),
                                      const SizedBox(height: 14),
                                      Text(
                                        'FERMAN!',
                                        style: TextStyle(
                                            color: c.era.primary,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 28),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        burstMessage!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Dokun ve sefere devam et',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomRealmNavigation extends StatelessWidget {
  const _BottomRealmNavigation({
    required this.selected,
    required this.labels,
    required this.icons,
    required this.accent,
    required this.highlight,
    required this.onTap,
  });

  final int selected;
  final List<String> labels;
  final List<IconData> icons;
  final Color accent;
  final Color highlight;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E4),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFDEC582).withValues(alpha: 0.95),
            width: 1.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3E311A).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(labels.length, (index) {
          final isCenter = index == 2;
          final isSelected = selected == index;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.only(top: isCenter ? 0 : 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: isCenter ? 72 : 50,
                      height: isCenter ? 72 : 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE5C568)
                              : const Color(0xFFD7CCB7),
                          width: isCenter ? 2.4 : 1.4,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isSelected
                              ? [
                                  Color.lerp(highlight, Colors.white, .22)!,
                                  isCenter
                                      ? accent
                                      : Color.lerp(accent, Colors.black, .08)!
                                ]
                              : [Colors.white, const Color(0xFFF0E7D4)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isCenter
                                ? accent.withValues(alpha: 0.28)
                                : const Color(0xFF41351C)
                                    .withValues(alpha: .08),
                            blurRadius: isCenter ? 14 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icons[index],
                        color: isSelected
                            ? (isCenter ? Colors.white : accent)
                            : const Color(0xFF777466),
                        size: isCenter ? 32 : 24,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: isCenter ? 11.5 : 10.5,
                        fontWeight:
                            isSelected ? FontWeight.w900 : FontWeight.w700,
                        color: isSelected ? accent : const Color(0xFF726B5F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
