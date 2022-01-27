class Hosts{
  Hosts({this.countrycode,
    required this.id, required this.contact,
    required this.Domain, required this.name,
    required this.emailid, });


  final String Domain;
  final String name;
  final int contact;
  final String id;
  final String emailid;
  final countrycode;

  factory Hosts.fromMap(Map<String,dynamic> data, String documentId){
    final String Domain=data['Domain'];
    final String name=data['name'];
    final int contct=data['contact'];
    final String emailid=data['emailid'];
    final countrycode=data['countrycode'];

    return Hosts(
      Domain: Domain,
      emailid: emailid ,
      contact: contct,
      name: name,
      id: documentId,
      countrycode:countrycode,
    );
  }

  Map<String,dynamic> toMap(){
    return{
      'countrycode':countrycode,
    'name':name,
    'emailid':emailid,
      'contact':contact,
      'Domain':Domain,


    };



  }
  }