import 'package:flutter/material.dart';

class WorkspaceNotice extends StatelessWidget {
  const WorkspaceNotice(
      {super.key,
      required this.examples,
      required this.loading,
      required this.onAction,
      this.error});
  final bool examples, loading;
  final String? error;
  final VoidCallback onAction;
  @override
  Widget build(BuildContext context) {
    if (!examples && !loading && error == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colors.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(children: [
        Icon(error != null ? Icons.cloud_off_outlined : Icons.layers_outlined,
            size: 18, color: colors.onSecondaryContainer),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
                loading
                    ? 'Çalışma alanı açılıyor…'
                    : error ??
                        'Örnek çalışma alanı · Kurgusal kayıtlar, kalıcı değişiklikler',
                style: TextStyle(
                    fontSize: 11, color: colors.onSecondaryContainer))),
        if (!loading)
          IconButton(
              onPressed: onAction,
              tooltip: error != null ? 'Yeniden dene' : 'Alanı değiştir',
              icon: Icon(error != null ? Icons.refresh : Icons.swap_horiz,
                  size: 20)),
      ]),
    );
  }
}
