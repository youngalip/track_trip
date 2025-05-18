import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:track_trip/models/schedule.dart';
import 'package:track_trip/services/mock_data_service.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  final MockDataService _mockDataService = MockDataService();
  
  ScheduleProvider() {
    _loadSchedules();
  }

  List<Schedule> get schedules => _schedules;

  Future<void> _loadSchedules() async {
    // Simulasi loading data dari backend
    _schedules = await _mockDataService.getMockSchedules();
    notifyListeners();
  }

  Future<void> addSchedule(
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    bool isAllDay,
    String? relatedBudgetId,
    String? location,
  ) async {
    final schedule = Schedule(
      id: const Uuid().v4(),
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      isAllDay: isAllDay,
      relatedBudgetId: relatedBudgetId,
      location: location,
    );

    _schedules.add(schedule);
    notifyListeners();
    
    // Simulasi penyimpanan ke backend
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index >= 0) {
      _schedules[index] = schedule;
      notifyListeners();
      
      // Simulasi update ke backend
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((schedule) => schedule.id == id);
    notifyListeners();
    
    // Simulasi delete dari backend
    await Future.delayed(const Duration(milliseconds: 300));
  }

  List<Schedule> getSchedulesByDate(DateTime date) {
    return _schedules.where((schedule) {
      final scheduleDate = DateTime(
        schedule.startTime.year,
        schedule.startTime.month,
        schedule.startTime.day,
      );
      final targetDate = DateTime(
        date.year,
        date.month,
        date.day,
      );
      return scheduleDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  List<Schedule> getSchedulesByDateRange(DateTime start, DateTime end) {
    return _schedules.where((schedule) {
      final scheduleDate = DateTime(
        schedule.startTime.year,
        schedule.startTime.month,
        schedule.startTime.day,
      );
      final startDate = DateTime(
        start.year,
        start.month,
        start.day,
      );
      final endDate = DateTime(
        end.year,
        end.month,
        end.day,
      );
      return (scheduleDate.isAfter(startDate) || scheduleDate.isAtSameMomentAs(startDate)) &&
             (scheduleDate.isBefore(endDate) || scheduleDate.isAtSameMomentAs(endDate));
    }).toList();
  }

  Schedule? getScheduleById(String id) {
    try {
      return _schedules.firstWhere((schedule) => schedule.id == id);
    } catch (e) {
      return null;
    }
  }
}
