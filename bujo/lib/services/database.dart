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

  Future addEvent(EventInfo event) async {
    await userDoc.collection('events').add({
      'name': event.name,
      'start': dateTimeFromEventTime(event.date, event.startTime),
      'end': dateTimeFromEventTime(event.date, event.endTime),
      'location': event.location,
    });
  }
}
