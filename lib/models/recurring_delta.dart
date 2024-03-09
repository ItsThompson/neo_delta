enum DeltaInterval { day, week, month }

// NOTE: smart icon selection (tag system?)
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

DeltaInterval parseStringToDeltaInterval(String deltaIntervalString) {
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

DateTime getCutoffDateOfDeltaInterval(DeltaInterval interval) {
  DateTime now = DateTime.now();

  switch (interval) {
    case DeltaInterval.day:
      return DateTime(now.year, now.month, now.day);
    case DeltaInterval.week:
      DateTime monday = now.subtract(Duration(days: now.weekday - 1));
      return DateTime(monday.year, monday.month, monday.day);
    case DeltaInterval.month:
      return DateTime(now.year, now.month, 1);
  }
}

DateTime startOfDeltaInterval(DeltaInterval interval, DateTime dateTime) {
  switch (interval) {
    case DeltaInterval.day:
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    case DeltaInterval.week:
      DateTime monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
      return DateTime(monday.year, monday.month, monday.day);
    case DeltaInterval.month:
      return DateTime(dateTime.year, dateTime.month, 1);
  }
}

List<DateTime> getStartOfIntervalDateTimesSinceDate(
    DeltaInterval interval, DateTime date) {
  List<DateTime> list = [];
  DateTime now = DateTime.now();

  list.add(date);
  DateTime nextDate = startOfDeltaInterval(interval, date);

  switch (interval) {
    case DeltaInterval.day:
      while (nextDate.isBefore(now) ||
          nextDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
        list.add(nextDate);
        nextDate.add(const Duration(days: 1));
      }
      return list;
    case DeltaInterval.week:
      while (nextDate.isBefore(now) ||
          nextDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
        list.add(nextDate);
        nextDate.add(const Duration(days: 7));
      }
      return list;
    case DeltaInterval.month:
      while (nextDate.isBefore(now) ||
          nextDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
        list.add(nextDate);
        nextDate = DateTime(nextDate.year, nextDate.month + 1, 1);
      }
      return list;
  }
}

// List<DateTime> rangeOfDeltaInterval(DeltaInterval interval, DateTime dateTime) {
//   switch (interval) {
//     case DeltaInterval.day:
//       DateTime startOfDay =
//           DateTime(dateTime.year, dateTime.month, dateTime.day);
//       DateTime endOfDay =
//           DateTime(dateTime.year, dateTime.month, dateTime.day + 1)
//               .subtract(const Duration(seconds: 1));
//       return <DateTime>[startOfDay, endOfDay];
//     case DeltaInterval.week:
//       DateTime monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
//       DateTime startOfMonday = DateTime(monday.year, monday.month, monday.day);
//       DateTime endOfSunday = startOfMonday
//           .add(const Duration(days: 7))
//           .subtract(const Duration(seconds: 1));
//       return <DateTime>[startOfMonday, endOfSunday];
//     case DeltaInterval.month:
//       DateTime beginningOfFirstDayOfMonth =
//           DateTime(dateTime.year, dateTime.month, 1);
//       DateTime endOfLastDayOfMonth = DateTime(
//               beginningOfFirstDayOfMonth.year,
//               beginningOfFirstDayOfMonth.month + 1,
//               beginningOfFirstDayOfMonth.day)
//           .subtract(const Duration(seconds: 1));
//       return <DateTime>[beginningOfFirstDayOfMonth, endOfLastDayOfMonth];
//   }
// }
