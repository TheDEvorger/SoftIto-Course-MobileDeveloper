import 'package:flutter/material.dart';

import '../../core/services/ai/pact_suggestion.dart';
import '../../core/state/realm_controller.dart';
import '../../core/theme/realm_theme.dart';
import '../../core/widgets/ornate_widgets.dart';

/// Interactive preview card for AI-suggested pacts.
/// Requires explicit user confirmation to sign the pact.
class PactSuggestionCard extends StatefulWidget {
  const PactSuggestionCard({
    super.key,
    required this.suggestion,
    this.realmController,
    this.onPactSigned,
  });

  final PactSuggestion suggestion;
  final RealmController? realmController;
  final VoidCallback? onPactSigned;

  @override
  State<PactSuggestionCard> createState() => _PactSuggestionCardState();
}

class _PactSuggestionCardState extends State<PactSuggestionCard> {
  bool _signed = false;

  void _signPact() {
    final c = widget.realmController;
    if (c == null) return;

    final s = widget.suggestion;
    // Map habit IDs or find active ones
    final available = c.activeHabits;
    final validIds = <String>[];

    for (final id in s.habitIds) {
      if (available.any((h) => h.id == id)) {
        validIds.add(id);
      }
    }

    if (validIds.isEmpty && available.isNotEmpty) {
      validIds.add(available.first.id);
    }

    if (validIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Ahit imzalamak için önce en az bir aktif vazifen olmalı.'),
        ),
      );
      return;
    }

    c.addPact(s.title, validIds, s.targetDays);
    setState(() => _signed = true);
    widget.onPactSigned?.call();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1B4332),
        content: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Color(0xFFFFD166)),
            const SizedBox(width: 8),
            Expanded(
              child: Text('“${s.title}” ahdi mühürlendi ve deftere işlendi!'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.suggestion;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: OrnateCard(
        color: const Color(0xFFFFFBF2),
        borderColor: const Color(0xFFE2C988),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HeraldicSeal(
                  icon: Icons.history_edu_rounded,
                  size: 34,
                  color: Color(0xFF7D2224),
                  borderColor: Color(0xFFFFD166),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ÖNERİLEN KRALLIK AHDİ',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF8B6415),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        s.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: RealmPalette.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_signed)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F4EA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF8FCFA9)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 12, color: Color(0xFF1B6B3E)),
                        SizedBox(width: 3),
                        Text(
                          'MÜHÜRLENDİ',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1B6B3E),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (s.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                s.description,
                style: const TextStyle(
                    fontSize: 12, height: 1.35, color: Color(0xFF4C4538)),
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDCD),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8C888)),
                  ),
                  child: Text(
                    '🎯 ${s.targetDays} Günlük Hedef',
                    style: const TextStyle(
                        fontSize: 10.5, fontWeight: FontWeight.w800),
                  ),
                ),
                if (s.habitNames.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFB5D1F8)),
                    ),
                    child: Text(
                      '🛡️ ${s.habitNames.join(", ")}',
                      style: const TextStyle(
                          fontSize: 10.5, fontWeight: FontWeight.w800),
                    ),
                  ),
              ],
            ),
            if (s.rationale.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3E6),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                      left: BorderSide(color: RealmPalette.gold, width: 2.5)),
                ),
                child: Text(
                  '“${s.rationale}”',
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF5E5445),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (!_signed)
              OrnateButton(
                label: 'Bu Ahdi İmzala ve Başlat',
                icon: Icons.history_edu_rounded,
                expanded: true,
                onPressed: widget.realmController != null ? _signPact : null,
              ),
          ],
        ),
      ),
    );
  }
}
