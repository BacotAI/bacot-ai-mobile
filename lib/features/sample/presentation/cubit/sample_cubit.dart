import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/sample_user.dart';
import '../../domain/repositories/sample_repository.dart';

part 'sample_state.dart';

class SampleCubit extends Cubit<SampleState> {
  final SampleRepository repository;

  SampleCubit({required this.repository}) : super(SampleInitial());

  Future<void> fetchUsers() async {
    try {
      emit(SampleLoading());
      final users = await repository.getUsers();
      emit(SampleLoaded(users));
    } catch (e) {
      emit(SampleError(e.toString()));
    }
  }
}
