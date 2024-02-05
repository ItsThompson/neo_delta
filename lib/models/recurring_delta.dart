enum DeltaInterval { day, week, month }

class RecurringDelta{
  final int id;
  final String name;
  final String iconSrc;
  final DeltaInterval deltaInterval;
  final int remainingFrequency;
  final bool completedToday;
  RecurringDelta({required this.id, required this.name, required this.iconSrc, required this.deltaInterval, required this.remainingFrequency, required this.completedToday});
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
