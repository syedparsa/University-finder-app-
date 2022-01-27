class campusEntry {
  campusEntry({
    required this.id,
    required this.start,
    required this.comment,
    required this.end,
    required this.duration,
    required this.CourseFee,

    required this.educationlevel,
    required this.admissionoffer,
    required this.details,


    required this.CourseId,
    required this.Credithours,

  });

  final String details;
  final String educationlevel;
  final String admissionoffer;
  final String CourseId;
  final int duration;
  final int CourseFee;
  final int Credithours;
  final DateTime start;
  final DateTime end;
  final String comment;

  final String id;
  double get durationIndays =>
      end.difference(start).inDays.toDouble() ;

  factory campusEntry.fromMap(Map<String, dynamic> value, String documentId) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    final String details=value['details'];
    final String educationlevel = value['educationlevel'];
    final String admissionoffer = value['admissionoffer'];
    final String CourseId = value['CourseId'];

    final int duration = value['duration'];
    final int CourseFee = value['CourseFee'];
    final int Credithours = value['Credithours'];


    return campusEntry(
        start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
        end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
        comment: value['comment'],
      details: details,
      educationlevel: educationlevel,
      admissionoffer: admissionoffer,
      CourseId: CourseId,
      duration: duration,
      Credithours: Credithours,
      CourseFee: CourseFee,


    id: documentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
      'details':details,
      'admissionoffer':admissionoffer,
      'educationlevel':educationlevel,
      'duration' :duration,
      'CourseId':CourseId,
      'Credithours':Credithours,
      'CourseFee':CourseFee,
    };
  }
}
