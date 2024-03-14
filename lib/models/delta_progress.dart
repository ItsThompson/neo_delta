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
  // Calculates delta for volume in interval.
  // NOTE  Assume that: minVolume <= effectiveVolume <= optimalVolume

  // NOTE  Deprecated Model(For Historical Record Only): https://www.desmos.com/calculator/tliclulinp
  // NOTE  Current Model: https://www.desmos.com/calculator/ejucssx4oc

  int base = max((optimalVolume - effectiveVolume), optimalVolume);
  int exponent = -((volume - optimalVolume).abs());

  if (volume <= 0) {
    return -1;
  }

  if (0 < volume && volume < minimumVolume) {
    return log(volume / minimumVolume);
  }

  if (minimumVolume <= volume && volume < effectiveVolume) {
    return 0;
  }

  if (effectiveVolume <= volume && volume < optimalVolume) {
    return pow(base, exponent).toDouble();
  }

  if (optimalVolume <= volume) {
    return 2 * pow(base, exponent).toDouble() - 1;
  }

  return -1;
}
