import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/domain/sample/entities/sample_user.dart';
import 'package:smart_interview_ai/domain/sample/repositories/sample_repository.dart';

part 'sample_event.dart';
part 'sample_state.dart';

@injectable
class SampleBloc extends Bloc<SampleEvent, SampleState> {
  final SampleRepository _repository;

  SampleBloc(this._repository) : super(SampleInitial()) {
    on<SampleUsersRequested>(_onUsersRequested);
  }

  FutureOr<void> _onUsersRequested(
    SampleUsersRequested event,
    Emitter<SampleState> emit,
  ) async {
    emit(SampleLoading());
    try {
      final users = await _repository.getUsers();
      emit(SampleLoaded(users));
    } catch (e) {
      emit(SampleError(e.toString()));
    }
  }
}
