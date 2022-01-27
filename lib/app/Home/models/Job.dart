class Job{
  Job({required this.id, required this.name, required this.ratePerHour});
  final String name;
  final int ratePerHour;
  final String id;
  factory Job.fromMap(Map<String,dynamic> data, String documentId){


  final String name=data['name'];
    final int  ratePerHour=data['ratePerHour'];


    return Job(
        ratePerHour: ratePerHour,
        name: name,
        id: documentId,
    );

  }

 Map<String,dynamic> toMap(){

    return {
      'name':name,
      'ratePerHour':ratePerHour,
     };
 }


}