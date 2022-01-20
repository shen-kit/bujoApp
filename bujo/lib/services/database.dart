// ignore_for_file: avoid_print

import 'package:bujo/shared/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final DocumentReference userDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  DateTime dateFromDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  //#region User

  Future createUser() async {
    DateTime now = DateTime.now();
    try {
      if (!await userExists()) {
        userDoc
            .collection('days')
            .doc(DateFormat('dd-MM-yyyy').format(now).toString())
            .set({
          'date': dateFromDateTime(now),
          'todos': [],
          'habit_completion': [],
        });
      }
    } catch (e) {
      print('error adding user document: $e');
    }
  }

  Future<bool> userExists() async => (await userDoc.get()).exists;

  Future deleteUserFromDb() async {
    try {
      QuerySnapshot snapshot = await userDoc.collection('days').get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      snapshot = await userDoc.collection('events').get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      snapshot = await userDoc.collection('habits').get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      await userDoc.delete();
    } catch (e) {
      print('error deleting user from db: $e');
    }
  }

  //#endregion User

  //#region Events

  Future addEvent(EventInfo event) async {
    await userDoc.collection('events').add({
      'name': event.name,
      'start': dateTimeFromEventTime(event.date, event.startTime),
      'end': dateTimeFromEventTime(event.date, event.endTime),
      'location': event.location,
      'full_day': event.fullDay,
    });
  }

  Future<List<EventInfo>> getEvents(DateTime date) async {
    QuerySnapshot snapshot = await userDoc
        .collection('events')
        .where('start',
            isGreaterThanOrEqualTo: dateFromDateTime(DateTime.now()),
            isLessThan: dateFromDateTime(DateTime.now().add(
              const Duration(days: 1),
            )))
        .get();

    List<EventInfo> events = [];
    for (var doc in snapshot.docs) {
      DateTime start = doc['start'].toDate();
      DateTime end = doc['end'].toDate();

      events.add(EventInfo(
        name: doc['name'],
        date: EventDate(
          year: start.year,
          month: start.month,
          date: start.day,
        ),
        fullDay: doc['full_day'],
        startTime: EventTime(start.hour, start.minute),
        endTime: EventTime(end.hour, end.minute),
        location: doc['location'],
        docId: doc.id,
      ));
    }
    return events;
  }

  // Future<List<EventInfo>> getEvents(int numberOfEvents) {

  // }

  List<EventInfo> _eventInfoFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      DateTime start = doc['start'].toDate();
      DateTime end = doc['end'].toDate();

      return EventInfo(
        name: doc['name'],
        date: EventDate(
          year: start.year,
          month: start.month,
          date: start.day,
        ),
        fullDay: doc['full_day'],
        startTime: EventTime(start.hour, start.minute),
        endTime: EventTime(end.hour, end.minute),
        location: doc['location'],
        docId: doc.id,
      );
    }).toList();
  }

  Stream<List<EventInfo>> get events {
    return userDoc.collection('events').snapshots().map(_eventInfoFromSnapshot);
  }

  Future deleteEvent(String? docId) =>
      userDoc.collection('events').doc(docId).delete();

  //#endregion Events

}
