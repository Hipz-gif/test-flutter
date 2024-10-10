import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  List<Map<String, dynamic>> transactions = [];

  ReportBloc() : super(ReportInitial()) {
    on<UploadFileEvent>(_onUploadFile);
    on<QueryTransactionsEvent>(_onQueryTransactions);
  }

  Future<void> _onUploadFile(
      UploadFileEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      transactions = await _extractDataFromExcel(event.excelFile);
      emit(ReportFileUploaded(transactions));
    } catch (e) {
      emit(ReportError(
          'Lỗi khi tải lên file hoặc đọc dữ liệu: ${e.toString()}'));
    }
  }

  Future<void> _onQueryTransactions(
      QueryTransactionsEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final totalAmount =
          _calculateTotal(event.startTime, event.endTime, transactions);
      emit(ReportQuerySuccess(totalAmount));
    } catch (e) {
      emit(ReportError('Lỗi khi truy vấn dữ liệu: ${e.toString()}'));
    }
  }

  Future<List<Map<String, dynamic>>> _extractDataFromExcel(File file) async {
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    final List<Map<String, dynamic>> extractedTransactions = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]?.rows ?? [];
      for (var row in sheet.skip(8)) {
        var dateValue = row[1]?.value?.toString() ?? '';
        var timeValue = row[2]?.value?.toString() ?? '';
        var amountValue = row[8]?.value?.toString().replaceAll(',', '') ?? '0';

        if (dateValue.isNotEmpty && timeValue.isNotEmpty) {
          extractedTransactions.add({
            'date': dateValue,
            'time': timeValue,
            'amount': amountValue,
          });
        }
      }
    }
    return extractedTransactions;
  }

  double _calculateTotal(
      DateTime start, DateTime end, List<Map<String, dynamic>> transactions) {
    double totalAmount = 0;

    print('Start time: $start');
    print('End time: $end');
    print('Transactions: $transactions'); //

    for (var transaction in transactions) {
      //Read date and time from data
      final String? dateString = transaction['Ngày']; // Column "Date"
      final String? timeString = transaction['Giờ']; // Column "Hours"
      final String? amountString =
          transaction['Thành tiền (VNĐ)']; // Column "Amount (VND)"

      if (dateString == null || timeString == null || amountString == null) {
        print('One of the required fields is null. Skipping this transaction.');
        continue; // Skip this transaction
      }

      final String combinedDateTimeString = '$dateString $timeString';
      print('Processing transaction: $combinedDateTimeString');

      if (combinedDateTimeString.isNotEmpty) {
        final DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");
        try {
          final DateTime dateTime =
              format.parse(combinedDateTimeString).toLocal();
          print('Parsed dateTime (local): $dateTime');

          DateTime startTime = DateTime(
              start.year, start.month, start.day, start.hour, start.minute);
          DateTime endTime =
              DateTime(end.year, end.month, end.day, end.hour, end.minute);
          DateTime transactionTime = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute);

          if (transactionTime.isAtSameMomentAs(startTime) ||
              (transactionTime.isAfter(startTime) &&
                  transactionTime.isBefore(endTime)) ||
              transactionTime.isAtSameMomentAs(endTime)) {
            // Process value into money
            print('Amount string: $amountString');

            // Remove commas to convert to double
            String cleanedAmountString =
                amountString.replaceAll(',', ''); // Remove commas
            double amount =
                double.tryParse(cleanedAmountString) ?? 0; // Convert to double

            totalAmount += amount;
            print('Amount added: $amount');
          } else {
            print('Skipped transaction outside of time range');
          }
        } catch (e) {
          print('Error parsing dateTime: $e');
        }
      }
    }

    print('Total amount: $totalAmount');
    return totalAmount;
  }
}
