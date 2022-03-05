class Subject {
  final String name;
  final String id;
  final double gpa;
  final int creditHrs;

  Subject({
    required this.creditHrs,
    required this.name,
    required this.id,
    required this.gpa,
  });

  factory Subject.fromPrefs(Map<String, dynamic> map) {
    return Subject(
        creditHrs: map['creditHrs'],
        name: map['name'],
        id: map['id'],
        gpa: map['gpa']);
  }
}
