import 'package:equatable/equatable.dart';

enum DeleteProfileStatus { initial, loading, success, error }

class DeleteProfileState extends Equatable {
  final DeleteProfileStatus status;
  final String? errorMessage;
  final String? successMessage;

  const DeleteProfileState({
    this.status = DeleteProfileStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  DeleteProfileState copyWith({
    DeleteProfileStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return DeleteProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
