class LandmarkDelta {
  final int id;
  final String name;
  final DateTime dateTime;
  final int weighting;
  final String description;

  LandmarkDelta({required this.id, required this.name, required this.dateTime, required this.weighting, required this.description});

  @override
  String toString() {
    return 'LandmarkDelta{id:$id, name:$name, date_time:$dateTime, weighting:$weighting, description:$description}';
  }
}
