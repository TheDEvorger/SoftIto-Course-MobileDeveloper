import 'package:flutter/material.dart';

Future<void> rentalAction(
    BuildContext context, Future<void> Function() action) async {
  try {
    await action();
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

Future<DateTimeRange?> rentalDates(BuildContext context,
    {DateTimeRange? initial}) async {
  final now = DateUtils.dateOnly(DateTime.now());
  return showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      initialDateRange:
          initial != null && !initial.start.isBefore(now) ? initial : null,
      helpText: 'Alış ve dönüş tarihlerini seçin',
      saveText: 'Tarihleri seç');
}
