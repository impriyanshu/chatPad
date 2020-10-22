
import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'api_path.dart';
import 'firestore_services.dart';

abstract class Database {
  Future<void> setJob1(String name , Reciever job);
  Future<void> setJob2(String name , Reciever job);
  Stream<List<Reciever>> jobsStreaminthatGroup(String name);
  Future<void> setJoball(Reciever job);
  Stream<List<Reciever>> jobsStream(String name);
  Stream<List<Reciever>> storyStream(String name);
  Stream<List<Reciever>> jobsStreamGroup(String name);
  Future<void> setUserna(UsernameClass usernameClass);
  Stream<List<UsernameClass>> usernaStream();
  Future<void> setRqstJob(String userid ,UsernameClass usernameClass);
  Future<void> addMessage(String chatRoomId, chatMessageData);
  getChats(String chatRoomId);
  Stream<List<Reciever>> allJobsStream();
  Stream<List<Reciever>> allGroupsStream();
  Stream<List<Reciever>> allGroupInUserStream(String name);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob1(String name , Reciever job) async => await _service.setData1(
    path: APIpath.job(name, job.id),
    data: job.toMap(),
  );

  @override
  Future<void> setJob2(String name , Reciever job) async => await _service.setData1(
    path: APIpath.job(name, job.id),
    data: job.toMap(),
  );

  @override
  Future<void> setJoball(Reciever job) async => await _service.setDataall(
    path: APIpath.joball(job.id),
    data: job.toMap(),
  );



  @override
  Future<void> setRqstJob(String userid ,UsernameClass usernameClass) async => await _service.setData(
    path: APIpath.addRqst(userid),
    data: usernameClass.toMap(),
  );

  @override
  Stream<List<Reciever>> jobsStream(String name) => _service.collectionStream(
    path: APIpath.jobs(name),
    builder: (data, documentId) => Reciever.fromMap(data, documentId),
  );

  @override
  Stream<List<Reciever>> jobsStreamGroup(String name) => _service.collectionStreamGroup(
    path: APIpath.jobs(name),
    builder: (data, documentId) => Reciever.fromMap(data, documentId),
  );

  @override
  Stream<List<Reciever>> jobsStreaminthatGroup(String name) => _service.collectionStreaminthatGroup(
    path: APIpath.ingroup(name),
    builder: (data, documentId) => Reciever.fromMap(data, documentId),
  );


  @override
  Stream<List<Reciever>> storyStream(String name) => _service.storyCollectionStream(
    path: APIpath.jobs(name),
    builder: (data, documentId) => Reciever.fromMap(data, documentId),
  );


  @override
  Future<void> setUserna(UsernameClass usernameClass) async => await _service.setUserData(
      path : APIpath.userna(uid),
      info : usernameClass.toMap()
  );



  @override
  Stream<List<UsernameClass>> usernaStream() => _service.collectionUsernaStream(
    path: '/users',
    builder: (info, documentId) => UsernameClass.fromMap(info, documentId),
  );

  Future<void> addMessage(String chatRoomId, chatMessageData){

    Firestore.instance.collection("chatlink")
        .document(chatRoomId)
        .collection("chat")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatlink")
        .document(chatRoomId)
        .collection("chat")
        .orderBy('time')
        .snapshots();
  }

  @override
  Stream<List<Reciever>> allJobsStream() => _service.collectionStreamall(
    path: APIpath.allJobs(),
    builder: (data, documentId) => Reciever.fromMap(data, documentId),
  );

  @override
  Stream<List<Reciever>> allGroupsStream() => _service.collectionGropusStreamall(
    path: APIpath.allGroupTotal(),
    builder: (data, documentId) => Reciever.fromMap(data, documentId),
  );

  @override
  Stream<List<Reciever>> allGroupInUserStream(String name) => _service.collectionGroupInUserStreamall(
    path: APIpath.allGroup(name),
    builder: (data, documentId) => Reciever.fromMap(data, documentId),
  );


}
