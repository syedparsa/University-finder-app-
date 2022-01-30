
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
enum SearchByCampuses { name,  country }
class Campuses with ChangeNotifier implements Comparable<Campuses> {
  Campuses({
    this.url,
    this.website,
    this.countrycode,
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

  final String? website;
        String? url;

  @override
  String toString() {
    return 'Campuses{'
        'url:$url,website:$website,  name: $name, city: $city, country: $country, address: $address, details: $details, CountryRanking: $CountryRanking, worldRanking: $worldRanking, id: $id}';
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
    final String website=data['website'];
    final String url=data['url'];
    final List<String?>? types = data['types'] != null
        ? (data['types'] as List).map((e) => e as String).toList()
        : null;
    return Campuses(
      url:url,
      website:website,

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
      'url':url,
      'website':website,

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




  @override
  int compareTo(Campuses other) {
    return this.name!.compareTo(other.name!);
  }
}
