
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Campuses {
  Campuses({this.countrycode,
     this.imageurl,

    this.name,
    this.city,
    this.address,
    this.details,
    this.id,
    this.country,
    this.CountryRanking,
    this.worldRanking,
  });
  static bool isSavedChanged = false;
  late final String? imageurl;

  final String? name;
  final String? city;
  final String? country;
  final String? address;
  final String? details;
  final int? CountryRanking;
  final int? worldRanking;
  final String? id;
  final String? countrycode;

  @override
  String toString() {
    return 'Campuses{name: $name, city: $city, country: $country, address: $address, details: $details, CountryRanking: $CountryRanking, worldRanking: $worldRanking, id: $id}';
  }

  factory Campuses.fromMap(Map<String, dynamic> data, String documentId) {
    print(data);
    final String? name = data['name'];
    final String? city = data['city'];
    final String? country = data['country'];
    final String? address = data['address'];
    final String? details = data['details'];
    final int? worldRanking = data['worldRanking'];
    final int? CountryRanking = data['CountryRanking'];
    final String imageurl=data['imageurl'];
    final String? countrycode=data['countrycode'];

    return Campuses(
      imageurl:imageurl,
      name: name,
      city: city,
      country: country,
      address: address,
      details: details,
      worldRanking: worldRanking,
      CountryRanking: CountryRanking,
      id: documentId,
      countrycode:countrycode,

    );
  }

  Map<String, dynamic> toMap() {

    return {
      'countrycode':countrycode,
      'imageurl':imageurl,
      'name': name,
      'city': city,
      'country': country,
      'address': address,
      'details': details,
      'worldRanking': worldRanking,
      'CountryRanking': CountryRanking,
    };
  }
}
