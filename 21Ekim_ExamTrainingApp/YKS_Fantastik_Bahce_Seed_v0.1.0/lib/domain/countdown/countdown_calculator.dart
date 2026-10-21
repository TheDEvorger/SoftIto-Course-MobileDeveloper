enum CountdownState { notSet, running, completed }

class CountdownResult {
  const CountdownResult({
    required this.state,
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
  });

  final CountdownState state;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  bool get isRunning => state == CountdownState.running;
  bool get isNotSet => state == CountdownState.notSet;
  bool get isCompleted => state == CountdownState.completed;
}

abstract final class CountdownCalculator {
  static CountdownResult calculate({
    required DateTime? targetDate,
    required DateTime now,
  }) {
    if (targetDate == null) {
      return const CountdownResult(state: CountdownState.notSet);
    }

    final diff = targetDate.difference(now);
    if (diff.isNegative || diff.inSeconds == 0) {
      return const CountdownResult(state: CountdownState.completed);
    }

    final totalSeconds = diff.inSeconds;
    final days = totalSeconds ~/ (24 * 3600);
    final hours = (totalSeconds % (24 * 3600)) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return CountdownResult(
      state: CountdownState.running,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }
}
