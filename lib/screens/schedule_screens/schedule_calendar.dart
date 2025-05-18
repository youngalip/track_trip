import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_trip/models/schedule.dart';
import 'package:track_trip/providers/schedule_provider.dart';
import 'package:track_trip/constants/app_strings.dart';
import 'package:track_trip/widgets/schedule_widgets/schedule_card.dart';

class ScheduleCalendarScreen extends StatefulWidget {
  const ScheduleCalendarScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleCalendarScreen> createState() => _ScheduleCalendarScreenState();
}

class _ScheduleCalendarScreenState extends State<ScheduleCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.schedule),
      ),
      body: Column(
        children: [
          TableCalendar<Schedule>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) {
              return Provider.of<ScheduleProvider>(context)
                  .getSchedulesByDate(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildScheduleList()),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    final schedules = Provider.of<ScheduleProvider>(context)
        .getSchedulesByDate(_selectedDay ?? DateTime.now());

    if (schedules.isEmpty) {
      return const Center(
        child: Text('Belum ada jadwal pada tanggal ini'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return ScheduleCard(schedule: schedule);
      },
    );
  }
}
