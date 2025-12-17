part of 'sample_cubit.dart';

abstract class SampleState extends Equatable {
  const SampleState();

  @override
  List<Object> get props => [];
}

class SampleInitial extends SampleState {}

class SampleLoading extends SampleState {}

class SampleLoaded extends SampleState {
  final List<SampleUser> users;

  const SampleLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class SampleError extends SampleState {
  final String message;

  const SampleError(this.message);

  @override
  List<Object> get props => [message];
}
