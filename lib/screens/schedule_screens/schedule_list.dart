import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/providers/schedule_provider.dart';
import 'package:track_trip/widgets/schedule_widgets/schedule_card.dart';
import 'package:track_trip/constants/app_strings.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final schedules = Provider.of<ScheduleProvider>(context).schedules;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.schedule),
      ),
      body: schedules.isEmpty
          ? const Center(child: Text('Belum ada jadwal'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return ScheduleCard(schedule: schedule);
              },
            ),
    );
  }
}
