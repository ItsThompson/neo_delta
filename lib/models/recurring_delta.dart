enum DeltaInterval { day, week, month }

// TODO: smart icon selection (tag system?)
class RecurringDelta {
  final int id;
  final String name;
  final String iconSrc;
  final DeltaInterval deltaInterval;
  final int weighting;
  final int remainingFrequency; // Remaining Frequency until Optimal Volume
  final int minimumVolume;
  final int effectiveVolume;
  final int optimalVolume;
  final DateTime startDate;
  final bool completedToday;
  RecurringDelta(
      {required this.id,
      required this.name,
      required this.iconSrc,
      required this.deltaInterval,
      required this.weighting,
      required this.remainingFrequency,
      required this.minimumVolume,
      required this.effectiveVolume,
      required this.optimalVolume,
      required this.startDate,
      required this.completedToday});
}

String getDeltaIntervalCurrentString(DeltaInterval interval) {
  switch (interval) {
    case DeltaInterval.day:
      return "TODAY";
    case DeltaInterval.week:
      return "THIS WEEK";
    case DeltaInterval.month:
      return "THIS MONTH";
  }
}

String getDeltaIntervalAdverbString(DeltaInterval interval) {
  switch (interval) {
    case DeltaInterval.day:
      return "DAILY";
    case DeltaInterval.week:
      return "WEEKLY";
    case DeltaInterval.month:
      return "MONTHLY";
  }
}

String getDeltaIntervalPeriodString(DeltaInterval interval) {
  switch (interval) {
    case DeltaInterval.day:
      return "DAY";
    case DeltaInterval.week:
      return "WEEK";
    case DeltaInterval.month:
      return "MONTH";
  }
}

DeltaInterval parseStringToDeltaInterval(String deltaIntervalString){
  switch (deltaIntervalString) {
      case "DAILY":
        return DeltaInterval.day;
      case "WEEK":
        return DeltaInterval.week;
      case "MONTH":
        return DeltaInterval.month;
      default:
        return DeltaInterval.day; // Default
    }
}

int calculateRemainingFrequencyForRecurringDelta(int id){
  // TODO: Remaining Frequency until Optimal Volume
  return 0;
}


bool recurringDeltaIsCompleted(int id){
  // TODO 
  return true;
}
