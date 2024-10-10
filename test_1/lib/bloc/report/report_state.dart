import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportFileUploaded extends ReportState {
  final List<Map<String, dynamic>> transactions;
  const ReportFileUploaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class ReportQuerySuccess extends ReportState {
  final double totalAmount;
  const ReportQuerySuccess(this.totalAmount);

  @override
  List<Object?> get props => [totalAmount];
}

class ReportError extends ReportState {
  final String message;
  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
