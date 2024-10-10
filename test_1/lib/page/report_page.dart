import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:test_1/bloc/report/report_bloc.dart';
import 'package:test_1/bloc/report/report_event.dart';
import 'package:test_1/bloc/report/report_state.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  bool _isPickingFile = false;

  Future<void> _pickDateTime(BuildContext context,
      TextEditingController controller, Function(DateTime) onSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onSelected(selectedDateTime);
        controller.text =
            DateFormat("dd/MM/yyyy HH:mm").format(selectedDateTime);
      }
    }
  }

  Future<void> _pickFile() async {
    if (_isPickingFile) return;
    setState(() {
      _isPickingFile = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        context.read<ReportBloc>().add(UploadFileEvent(file));
      }
    } finally {
      setState(() {
        _isPickingFile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _isPickingFile ? null : _pickFile,
                child: const Text('Upload Excel File'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _startTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Giờ Bắt Đầu',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _pickDateTime(context, _startTimeController, (dateTime) {
                        selectedStartTime = dateTime;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _endTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Giờ Kết Thúc',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _pickDateTime(context, _endTimeController, (dateTime) {
                        selectedEndTime = dateTime;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedStartTime != null && selectedEndTime != null) {
                    context.read<ReportBloc>().add(QueryTransactionsEvent(
                        selectedStartTime!, selectedEndTime!));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Vui lòng chọn giờ bắt đầu và giờ kết thúc.')),
                    );
                  }
                },
                child: const Text('Truy vấn'),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is ReportLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ReportQuerySuccess) {
                    return Text('Tổng Thành tiền: ${state.totalAmount}');
                  } else if (state is ReportError) {
                    return Text('Lỗi: ${state.message}');
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
