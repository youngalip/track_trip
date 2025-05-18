import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_trip/models/schedule.dart';
import 'package:track_trip/providers/schedule_provider.dart';
import 'package:track_trip/constants/app_strings.dart';
import 'package:track_trip/widgets/common/custom_button.dart';
import 'package:track_trip/widgets/common/custom_text_field.dart';
import 'package:intl/intl.dart';

class ScheduleFormScreen extends StatefulWidget {
  final Schedule? schedule; // null untuk tambah baru

  const ScheduleFormScreen({Key? key, this.schedule}) : super(key: key);

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));
  bool _isAllDay = false;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _titleController.text = widget.schedule!.title;
      _descriptionController.text = widget.schedule!.description;
      _locationController.text = widget.schedule!.location ?? '';
      _startTime = widget.schedule!.startTime;
      _endTime = widget.schedule!.endTime;
      _isAllDay = widget.schedule!.isAllDay;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({
    required bool isStart,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
    );
    if (time == null) return;

    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      if (isStart) {
        _startTime = dateTime;
        if (_endTime.isBefore(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = dateTime;
        if (_endTime.isBefore(_startTime)) {
          _startTime = _endTime.subtract(const Duration(hours: 1));
        }
      }
    });
  }

  void _saveSchedule() {
    if (!_formKey.currentState!.validate()) return;

    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);

    if (widget.schedule == null) {
      scheduleProvider.addSchedule(
        _titleController.text,
        _descriptionController.text,
        _startTime,
        _endTime,
        _isAllDay,
        null,
        _locationController.text.isEmpty ? null : _locationController.text,
      );
    } else {
      final updatedSchedule = Schedule(
        id: widget.schedule!.id,
        title: _titleController.text,
        description: _descriptionController.text,
        startTime: _startTime,
        endTime: _endTime,
        isAllDay: _isAllDay,
        relatedBudgetId: widget.schedule!.relatedBudgetId,
        location: _locationController.text.isEmpty ? null : _locationController.text,
      );
      scheduleProvider.updateSchedule(updatedSchedule);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule == null ? AppStrings.addSchedule : AppStrings.editSchedule),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: AppStrings.scheduleTitle,
                validator: (value) => value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                labelText: AppStrings.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(AppStrings.allDay),
                value: _isAllDay,
                onChanged: (val) {
                  setState(() {
                    _isAllDay = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Waktu Mulai: ${DateFormat('dd MMM yyyy HH:mm').format(_startTime)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDateTime(isStart: true),
              ),
              ListTile(
                title: Text('Waktu Selesai: ${DateFormat('dd MMM yyyy HH:mm').format(_endTime)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDateTime(isStart: false),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _locationController,
                labelText: AppStrings.location,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.save,
                onPressed: _saveSchedule,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
