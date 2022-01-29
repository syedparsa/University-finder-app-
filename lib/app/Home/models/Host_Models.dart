class Hosts {
  Hosts({
    this.url,
    this.imageurl,
    required this.address,
    required this.details,


    this.countrycode,
    required this.id,
    required this.contact,
    required this.Domain,
    required this.name,
    required this.emailid,
  });

  static bool isSavedChanged = false;

  late final String? imageurl;
  final String Domain;
  final String name;
  final int contact;
  final String id;
  final String emailid;
  final countrycode;
  final String address;
  final String details;


  String? url;


  @override
  String toString() {
    return 'Hosts{'
        'photourl:$imageurl,'
        'website:$Domain,  '
        'name: $name, contact: $contact, emailid: $emailid, countrycode: $countrycode,'
        ' details: $details, address: $address, isSavedChanged: $isSavedChanged, id: $id}';
  }
  factory Hosts.fromMap(Map<String, dynamic> data, String documentId) {
    final String Domain = data['Domain'];
    final String name = data['name'];
    final int  contct = data['contact'];
    final String imageurl=data['imageurl'];
    final String  emailid = data['emailid'];
    final String countrycode = data['countrycode'];
    final String address=data['address'];
    final String details=data['details'];
    final String?   url=data['url'];

    return Hosts(
      url:url,
      imageurl:imageurl,
      address: address,
      details: details,


      Domain: Domain,
      emailid: emailid,
      contact: contct,
      name: name,
      id: documentId,
      countrycode: countrycode,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'imageurl':imageurl,
      'address':address,
      'details':details,

      'countrycode': countrycode,
      'name': name,
      'emailid': emailid,
      'contact': contact,
      'Domain': Domain,
    };
  }
}
