// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bujo/shared/event.dart';
import 'package:bujo/shared/habit.dart';
import 'package:bujo/shared/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  DatabaseService({this.dateOffset = 0, this.calendarEventsToLoad = 15});

  int dateOffset;
  int calendarEventsToLoad = 15;

  final DocumentReference userDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  DateTime dateFromDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  String formatDate(int _dateOffset) {
    DateTime date = DateTime.now().add(Duration(days: _dateOffset));
    return DateFormat('dd-MM-yyyy').format(date).toString();
  }

  Future createDateIfNotExist(int _dateOffset) async {
    DateTime date = DateTime.now().add(Duration(days: _dateOffset));
    bool dayDocExists =
        (await userDoc.collection('days').doc(formatDate(_dateOffset)).get())
            .exists;
    if (!dayDocExists) {
      userDoc
          .collection('days')
          .doc(formatDate(_dateOffset))
          .set({'date': date});
    }
  }

  //#region User

  Future createUser() async {
    DateTime now = DateTime.now();
    try {
      if (!await userExists()) {
        userDoc.collection('days').doc(formatDate(dateOffset)).set({
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

  Future updateEvent(EventInfo event) async {
    await userDoc.collection('events').doc(event.docId).update({
      'name': event.name,
      'start': dateTimeFromEventTime(event.date, event.startTime),
      'end': dateTimeFromEventTime(event.date, event.endTime),
      'location': event.location,
      'full_day': event.fullDay,
    });
  }

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

  Stream<List<EventInfo>> get dailyEvents {
    return userDoc
        .collection('events')
        .where('start',
            isGreaterThanOrEqualTo: dateFromDateTime(DateTime.now().add(
              Duration(days: dateOffset),
            )),
            isLessThan: dateFromDateTime(DateTime.now().add(
              Duration(days: 1 + dateOffset),
            )))
        .orderBy('start')
        .snapshots()
        .map(_eventInfoFromSnapshot);
  }

  Map<DateTime, List<EventInfo>> _calendarEventsFromSnapshot(
      QuerySnapshot snapshot) {
    Map<DateTime, List<EventInfo>> events = {};

    for (var doc in snapshot.docs) {
      DateTime start = doc['start'].toDate();
      DateTime end = doc['end'].toDate();

      DateTime date = DateTime(start.year, start.month, start.day);

      if (events[date] == null) {
        events[date] = [];
      }

      events[date]!.add(
        EventInfo(
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
        ),
      );
    }

    return events;
  }

  Stream<Map<DateTime, List<EventInfo>>> get calendarEvents {
    return userDoc
        .collection('events')
        .where(
          'start',
          isGreaterThanOrEqualTo: dateFromDateTime(
            DateTime.now().add(Duration(days: dateOffset)),
          ),
        )
        .orderBy('start')
        .limit(calendarEventsToLoad)
        .snapshots()
        .map(_calendarEventsFromSnapshot);
  }

  void loadMoreCalendarEvents() {
    calendarEventsToLoad += 10;
  }

  Future deleteEvent(String? docId) =>
      userDoc.collection('events').doc(docId).delete();

  //#endregion Events

  //#region To Dos

  Future addTodo(TodoInfo todo,
      {bool nextDay = false, previousDay = false}) async {
    int _dateOffset = nextDay
        ? dateOffset + 1
        : previousDay
            ? dateOffset - 1
            : dateOffset;
    await createDateIfNotExist(_dateOffset);
    await userDoc
        .collection('days')
        .doc(formatDate(_dateOffset))
        .collection('todos')
        .add(
      {
        'name': todo.name,
        'done': todo.done,
        'category': todo.category,
        'order': todo.order,
      },
    );
  }

  Future updateTodo(TodoInfo todo) async {
    await userDoc
        .collection('days')
        .doc(formatDate(dateOffset))
        .collection('todos')
        .doc(todo.docId)
        .update({
      'name': todo.name,
      'done': todo.done,
      'category': todo.category,
      'order': todo.order,
    });
  }

  Future toggleTodoDone(TodoInfo todo) async {
    userDoc
        .collection('days')
        .doc(formatDate(dateOffset))
        .collection('todos')
        .doc(todo.docId)
        .update({'done': !todo.done});
  }

  List<TodoInfo> _todoInfoFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => TodoInfo(
              docId: doc.id,
              name: doc['name'],
              done: doc['done'],
              category: doc['category'],
              order: doc['order'],
            ))
        .toList();
  }

  Stream<List<TodoInfo>> get dailyTodos {
    return userDoc
        .collection('days')
        .doc(formatDate(dateOffset))
        .collection('todos')
        .orderBy('order')
        .snapshots()
        .map(_todoInfoFromSnapshot);
  }

  Future migrateToDo(TodoInfo todo, bool forward) async {
    userDoc
        .collection('days')
        .doc(formatDate(dateOffset))
        .collection('todos')
        .doc(todo.docId)
        .delete();

    QuerySnapshot snapshot = await userDoc
        .collection('days')
        .doc(formatDate(forward ? dateOffset + 1 : dateOffset - 1))
        .collection('todos')
        .get();

    int todosInMigratingDay = snapshot.docs.length;

    TodoInfo newTodo = TodoInfo(
      docId: todo.docId,
      name: todo.name,
      done: todo.done,
      category: todo.category,
      order: todosInMigratingDay,
    );

    addTodo(newTodo, nextDay: forward, previousDay: !forward);
  }

  Future reorderTodos(List<String> docIdsOrdered) async {
    for (int i = 0; i < docIdsOrdered.length; i++) {
      userDoc
          .collection('days')
          .doc(formatDate(dateOffset))
          .collection('todos')
          .doc(docIdsOrdered[i])
          .update({'order': i});
    }
  }

  Future deleteTodo(String? docId) {
    return userDoc
        .collection('days')
        .doc(formatDate(dateOffset))
        .collection('todos')
        .doc(docId)
        .delete();
  }

  //#endregion To Dos

  //#region Habits

  Future addHabit(HabitInfo habit) async {
    await userDoc.collection('habits').add({
      'name': habit.name,
      'description': habit.description,
      'partial_requirement': habit.partialRequirement,
      'completed': 0,
      'partially_completed': 0,
      'failed': 0,
      'excused': 0,
      'start_date': habit.startDate,
      'end_date': null,
      'order': habit.order,
    });
  }

  Future updateHabit(HabitInfo habit) async {
    await userDoc.collection('habits').doc(habit.docId).update({
      'name': habit.name,
      'description': habit.description,
      'partial_requirement': habit.partialRequirement,
    });
  }

  List<List<HabitInfo>> _habitsFromSnapshot(QuerySnapshot snapshot) {
    List<HabitInfo> current = [];
    List<HabitInfo> finished = [];
    for (var doc in snapshot.docs) {
      HabitInfo habit = HabitInfo(
        name: doc['name'],
        description: doc['description'],
        partialRequirement: doc['partial_requirement'],
        completed: doc['completed'],
        partiallyCompleted: doc['partially_completed'],
        failed: doc['failed'],
        excused: doc['excused'],
        startDate: doc['start_date'].toDate(),
        endDate: doc['end_date']?.toDate(),
        order: doc['order'],
        docId: doc.id,
      );

      if (doc['end_date'] == null) {
        current.add(habit);
      } else {
        finished.add(habit);
      }
    }

    return [current, finished];
  }

  // index 0 = current, index 1 = completed
  Stream<List<List<HabitInfo>>> get habits {
    return userDoc
        .collection('habits')
        .orderBy('order')
        .snapshots()
        .map(_habitsFromSnapshot);
  }

  Future finishHabit(String docId) async {
    await userDoc.collection('habits').doc(docId).update({
      'end_date': dateFromDateTime(DateTime.now()),
    });
  }

  Future deleteHabit(String docId) async {
    DocumentSnapshot habitDoc =
        await userDoc.collection('habits').doc(docId).get();

    DateTime startDate = habitDoc['start_date'].toDate();
    DateTime endDate = habitDoc['end_date'].toDate();

    int daysCount = endDate.difference(startDate).inDays;

    // go through all dates between start and end to delete habit completion
    for (var i = 0; i < daysCount; i++) {
      DateTime date = startDate.add(Duration(days: i));
      int offset = dateFromDateTime(DateTime.now()).difference(date).inDays;

      await userDoc
          .collection('days')
          .doc(formatDate(offset))
          .collection('habit_completion')
          .doc(docId)
          .delete();
    }

    // delete habit
    await userDoc.collection('habits').doc(docId).delete();
  }

  Future onHabitStatusChanged(
      String docId, String changedFrom, String changedTo) async {
    if (changedFrom.isNotEmpty) {
      int initial =
          (await userDoc.collection('habits').doc(docId).get())[changedFrom];
      // subtract one from changedFrom
      await userDoc
          .collection('habits')
          .doc(docId)
          .update({changedFrom: --initial});
    }

    if (changedTo.isNotEmpty) {
      // add one to changedTo
      int initial =
          (await userDoc.collection('habits').doc(docId).get())[changedTo];
      await userDoc
          .collection('habits')
          .doc(docId)
          .update({changedTo: ++initial});
    }
  }

  //#endregion Habits

  //#region Daily Habits

  Future<List<HabitInfo>> getCurrentHabits(int _dateOffset) async {
    // get habit documents without an end date and that started before this date
    QuerySnapshot snapshot = await userDoc
        .collection('habits')
        // .orderBy('order')
        .where('end_date', isNull: true)
        .where(
          'start_date',
          isLessThanOrEqualTo: dateFromDateTime(
            DateTime.now().add(Duration(days: _dateOffset)),
          ),
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => HabitInfo(
            name: doc['name'],
            description: '',
            partialRequirement: '',
            completed: doc['completed'],
            partiallyCompleted: doc['partially_completed'],
            failed: doc['failed'],
            excused: doc['excused'],
            startDate: doc['start_date'].toDate(),
            endDate: null,
            order: doc['order'],
            docId: doc.id,
          ),
        )
        .toList();
  }

  // return true if added at least 1 doc, keep iterating
  Future<bool> addHabitCompletionDocs(int _dateOffset) async {
    List<HabitInfo> currentHabits = await getCurrentHabits(_dateOffset);

    bool added = false;
    for (var habit in currentHabits) {
      // if a doc for this habit already exists, skip it
      if ((await userDoc
              .collection('days')
              .doc(formatDate(_dateOffset))
              .collection('habit_completion')
              .get())
          .docs
          .map((e) => e.id)
          .toList()
          .contains(habit.docId)) {
        continue;
      }

      userDoc
          .collection('days')
          .doc(formatDate(_dateOffset))
          .collection('habit_completion')
          .doc(habit.docId)
          .set(
        {
          'name': habit.name,
          'status': 'future',
        },
      );

      added = true;
    }
    if (added) return true;
    return false;
  }

  Future addHabitCompletionUntilToday() async {
    int _dateOffset = 0;
    bool iterate = true;
    do {
      await createDateIfNotExist(_dateOffset);
      iterate = await addHabitCompletionDocs(_dateOffset);
      _dateOffset--;
    } while (iterate);
  }

  List<HabitCompletionInfo> _habitCompletionFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (doc) => HabitCompletionInfo(
            docId: doc.id,
            name: doc['name'],
            status: doc['status'],
          ),
        )
        .toList();
  }

  Stream<List<HabitCompletionInfo>> get habitCompletion {
    return userDoc
        .collection('days')
        .doc(formatDate(dateOffset))
        .collection('habit_completion')
        .snapshots()
        .map(_habitCompletionFromSnapshot);
  }

  Future setHabitCompletionStatus(String docId, String status) async {
    await userDoc
        .collection('days')
        .doc(formatDate(dateOffset))
        .collection('habit_completion')
        .doc(docId)
        .update({'status': status});
  }

  //#endregion Daily Habits

}
