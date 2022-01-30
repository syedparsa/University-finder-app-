class Courses {
  Courses({ this.start,  this.end,  this.comment,
    required this.duration,
    required this.CourseFee,
    required this.name,
    required this.educationlevel,
    required this.admissionoffer,
    required this.details,
    required this.id,

    required this.CourseId,
    required this.Credithours,
  });



  final DateTime? start;
  final DateTime? end;
  final String? comment;



  final String? name;
  final String? details;
  final String? educationlevel;
  final String? admissionoffer;
  final String?    CourseId;
  final int?    duration;
  final int? CourseFee;
  final int? Credithours;


  final String id;



  factory Courses.fromMap(Map<String, dynamic> data, String documentId) {


    final String name = data['name'];
    final String details=data['details'];
    final String educationlevel = data['educationlevel'];
    final String admissionoffer = data['admissionoffer'];
    final String CourseId = data['CourseId'];

    final int duration = data['duration'];
    final int CourseFee = data['CourseFee'];
    final int Credithours = data['Credithours'];



    return Courses(

      comment: data['comment'],

      name: name,
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
      'start': start?.millisecondsSinceEpoch,
      'end': end?.millisecondsSinceEpoch,
      'comment': comment,

      'name': name,
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
