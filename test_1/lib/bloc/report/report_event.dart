import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class UploadFileEvent extends ReportEvent {
  final File excelFile;
  const UploadFileEvent(this.excelFile);

  @override
  List<Object?> get props => [excelFile];
}

class QueryTransactionsEvent extends ReportEvent {
  final DateTime startTime;
  final DateTime endTime;
  const QueryTransactionsEvent(this.startTime, this.endTime);

  @override
  List<Object?> get props => [startTime, endTime];
}
