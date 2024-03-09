import 'dart:math';

class DeltaProgress {
  final int id;
  final int deltaId;
  final DateTime completedAt;

  DeltaProgress(
      {required this.id, required this.deltaId, required this.completedAt});
}

double calculateDelta(
    int volume, int minimumVolume, int effectiveVolume, int optimalVolume) {
  // See: https://www.desmos.com/calculator/t57he69cvo
  if (0 <= volume && volume < minimumVolume) {
    return sin((pi * volume) / (2 * minimumVolume)) - 1;
  }

  if (minimumVolume <= volume && volume < effectiveVolume) {
    return 0;
  }

  if (effectiveVolume <= volume &&
      volume < (3 * optimalVolume - 2 * effectiveVolume)) {
    return sin(pi *
        (volume - effectiveVolume) /
        (2 * (optimalVolume - effectiveVolume)));
  }

  return 0;
}
