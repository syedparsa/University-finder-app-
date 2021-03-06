import 'dart:io';

import 'package:dream_university_finder_app/Services/Api_Path.dart';
import 'package:dream_university_finder_app/Services/Services_FireStore.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Entry_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Courses_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Entry_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Job.dart';
import 'package:dream_university_finder_app/app/Home/models/entry.dart';
import 'package:dream_university_finder_app/app/Home/models/user_Model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class Database {
  Future<String> uploadImage(File image, String imagePath);

  Future<void> deleteImage(String imagePath);

  Future<String> downloadImage(String imagePath);

  Future<void> SetCampus(Campuses uni);

  Future<void> DeleteCampus(Campuses uni);

  Stream<List<Campuses>> CampusesStream();

  Future<void> SetHost(Hosts host);

  Future<void> DeleteHost(Hosts host);

  Stream<List<Hosts>> HostsStream();

  Future<void> SetCourse(Courses course);

  Future<void> DeleteCourse(Courses course);

  Stream<List<Courses>> CoursesStream();

  Future<void> setcampusEntry(campusEntry entry);

  Future<void> deletecampusEntry(campusEntry entry);

  Stream<List<campusEntry>> campusentriesStream({Campuses? course});

  Future<void> sethostEntry(HostsEntry entry);

  Future<void> deletehostEntry(HostsEntry entry);

  Stream<List<HostsEntry>> hostentriesStream();

  Future<void> setjobEntry(Entry entry);

  Future<void> deletejobEntry(Entry entry);

  Stream<List<Entry>> jobentriesStream({Job? job});

  Future<void> deleteUser(EndUser user,String uid);

  Future<void> setUser(EndUser user, String uid);

  Stream<List<EndUser>> usersStream();
}

String DocumentIDfromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({this.uid});

  FirebaseStorage storage = FirebaseStorage.instance;

  final String? uid;

  final _service = FirestoreService.instance;

//TODO:USER:
  @override
  Future<void> deleteUser(EndUser user, String uid) => _service.deleteData(
        path: APIPATH.user(uid ),
      );

  @override
  Future<void> setUser(EndUser user, String uid) => _service.setData(
        path: APIPATH.user(uid),
        data: user.toMap(),
      );

  @override
  Stream<List<EndUser>> usersStream() => _service.collectionStream(
        path: APIPATH.users(),
        builder: (data, documentId) => EndUser.fromMap(data, documentId),
      );


//TODO:University manual database
  @override
  Future<void> SetCampus(Campuses uni) => _service.setData(
        path: APIPATH.campus(uni.id!),
        data: uni.toMap(),
      );

  @override
  Future<void> SetHost(Hosts host) => _service.setData(
        path: APIPATH.host(host.id),
        data: host.toMap(),
      );

  @override
  Future<void> SetCourse(Courses course) => _service.setData(
        path: APIPATH.course(course.id),
        data: course.toMap(),
      );

  @override
  Future<void> DeleteCampus(Campuses uni) async {
    final allEntries = await campusentriesStream(course: uni).first;
    for (campusEntry entry in allEntries) {
      if (entry.CourseId == uni.id) {
        await deletecampusEntry(entry);
      }
    }

    await _service.deleteData(
      path: APIPATH.campus(uni.id!),
    );
  }

  @override
  Future<void> DeleteCourse(Courses course) => _service.deleteData(
        path: APIPATH.course(course.id),
      );

  @override
  Future<void> DeleteHost(Hosts host)
      /*  */ /*final allEntries = await hostentriesStream(host: host).first;
    for (HostsEntry entry in allEntries) {
      if (entry.CourseId == host.id) {
        await deletehostEntry(entry);
      }
    }*/ /*
    await*/
      =>
      _service.deleteData(
        path: APIPATH.host(host.id),
      );

  @override
  Stream<List<Campuses>> CampusesStream() => _service.collectionStream(
        path: APIPATH.campuses(uid!),
        builder: (data, documentId) {
          return Campuses.fromMap(data, documentId);
        },
      );

  @override
  Stream<List<Courses>> CoursesStream() => _service.collectionStream(
        path: APIPATH.courses(uid!),
        builder: (data, documentId) => Courses.fromMap(data, documentId),
      );

  @override
  Stream<List<Hosts>> HostsStream() => _service.collectionStream(
        path: APIPATH.hosts(uid!),
        builder: (data, documentId) => Hosts.fromMap(data, documentId),
      );

  //TODO: addding campus enteries
  @override
  Future<void> setcampusEntry(campusEntry entry) => _service.setData(
        path: APIPATH.entry(entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deletecampusEntry(campusEntry entry) => _service.deleteData(
        path: APIPATH.entry(entry.id),
      );

  @override
  Stream<List<campusEntry>> campusentriesStream({Campuses? course}) =>
      _service.collectionStream<campusEntry>(
        path: APIPATH.entries(uid!),
        queryBuilder: course != null
            ? (query) => query.where('CourseId', isEqualTo: course.id)
            : null,
        builder: (data, documentID) => campusEntry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  //TODO: addding Hosts enteries
  @override
  Future<void> sethostEntry(HostsEntry entry) => _service.setData(
        path: APIPATH.hostentry(uid!, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deletehostEntry(HostsEntry entry) => _service.deleteData(
        path: APIPATH.hostentry(uid!, entry.id),
      );

  @override
  Stream<List<HostsEntry>> hostentriesStream() => _service.collectionStream(
        path: APIPATH.hostentries(uid!),
        builder: (data, documentId) => HostsEntry.fromMap(data, documentId),
      );

  //TODO:JOb ENtries

  @override
  Future<void> setjobEntry(Entry entry) => _service.setData(
        path: APIPATH.entry(entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deletejobEntry(Entry entry) => _service.deleteData(
        path: APIPATH.entry(entry.id),
      );

  @override
  Stream<List<Entry>> jobentriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPATH.entries(uid!),
        queryBuilder: job != null
            ? (query) => query.where('JobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Future<void> deleteImage(String imagePath) async {
    var storageRef = storage.ref().child(imagePath);
    await storageRef.delete();
  }

  @override
  Future<String> downloadImage(String imagePath) async {
    var storageRef = storage.ref().child(imagePath);
    return await storageRef.getDownloadURL();
  }

  @override
  Future<String> uploadImage(File image, String imagePath) async {
    var storageRef = storage.ref().child(imagePath);
    var uploadTask = await storageRef.putFile(image);
    return await uploadTask.ref.getDownloadURL();
  }
}
