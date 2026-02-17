import 'package:equatable/equatable.dart';

enum BugReportStatus { initial, loading, success, error }

class BugReportState extends Equatable {
  final BugReportStatus status;
  final String? errorMessage;

  const BugReportState({
    this.status = BugReportStatus.initial,
    this.errorMessage,
  });

  factory BugReportState.initial() {
    return const BugReportState();
  }

  BugReportState copyWith({BugReportStatus? status, String? errorMessage}) {
    return BugReportState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
