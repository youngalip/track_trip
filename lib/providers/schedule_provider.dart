import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:track_trip/models/schedule.dart';

class ScheduleProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'schedules';

  List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules;

  ScheduleProvider() {
    _listenToSchedules();
  }

  // Mendengarkan perubahan realtime di Firestore
  void _listenToSchedules() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .listen((snapshot) {
      _schedules = snapshot.docs.map((doc) => Schedule.fromFirestore(doc)).toList();
      notifyListeners();
    }, onError: (error) {
      if (kDebugMode) {
        print('Error listening to schedules: $error');
      }
    });
  }

  // Tambah jadwal baru ke Firestore
  Future<void> addSchedule(
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    bool isAllDay,
    String? relatedBudgetId,
    String? location,
  ) async {
    final id = const Uuid().v4();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    try {
      await _firestore.collection(_collection).doc(id).set({
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'isAllDay': isAllDay,
        'relatedBudgetId': relatedBudgetId,
        'location': location,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Schedule added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add schedule: $e');
      }
      rethrow;
    }
  }

  // Update jadwal di Firestore
  Future<void> updateSchedule(Schedule schedule) async {
    try {
      final Map<String, dynamic> data = schedule.toMap();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_collection).doc(schedule.id).update(data);

      if (kDebugMode) {
        print('Schedule updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update schedule: $e');
      }
      rethrow;
    }
  }

  // Hapus jadwal dari Firestore
  Future<void> deleteSchedule(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();

      if (kDebugMode) {
        print('Schedule deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete schedule: $e');
      }
      rethrow;
    }
  }

  // Dapatkan jadwal berdasarkan tanggal
  List<Schedule> getSchedulesByDate(DateTime date) {
    return _schedules.where((schedule) {
      final scheduleDate = DateTime(schedule.startTime.year, schedule.startTime.month, schedule.startTime.day);
      final targetDate = DateTime(date.year, date.month, date.day);
      return scheduleDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  // Dapatkan jadwal berdasarkan rentang tanggal
  List<Schedule> getSchedulesByDateRange(DateTime start, DateTime end) {
    return _schedules.where((schedule) {
      final scheduleDate = DateTime(schedule.startTime.year, schedule.startTime.month, schedule.startTime.day);
      final startDate = DateTime(start.year, start.month, start.day);
      final endDate = DateTime(end.year, end.month, end.day);
      return (scheduleDate.isAfter(startDate) || scheduleDate.isAtSameMomentAs(startDate)) &&
          (scheduleDate.isBefore(endDate) || scheduleDate.isAtSameMomentAs(endDate));
    }).toList();
  }

  // Dapatkan jadwal berdasarkan ID
  Schedule? getScheduleById(String id) {
    try {
      return _schedules.firstWhere((schedule) => schedule.id == id);
    } catch (e) {
      return null;
    }
  }

  // Dapatkan jadwal berdasarkan budget ID
  List<Schedule> getSchedulesByBudgetId(String budgetId) {
    return _schedules.where((schedule) => schedule.relatedBudgetId == budgetId).toList();
  }

  // Dapatkan jadwal yang akan datang
  List<Schedule> getUpcomingSchedules() {
    final now = DateTime.now();
    return _schedules.where((schedule) => schedule.startTime.isAfter(now)).toList();
  }

  // Dapatkan jadwal yang sudah lewat
  List<Schedule> getPastSchedules() {
    final now = DateTime.now();
    return _schedules.where((schedule) => schedule.endTime.isBefore(now)).toList();
  }

  // Dapatkan jadwal yang sedang berlangsung
  List<Schedule> getOngoingSchedules() {
    final now = DateTime.now();
    return _schedules.where((schedule) =>
        schedule.startTime.isBefore(now) && schedule.endTime.isAfter(now)).toList();
  }
}
