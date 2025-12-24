import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_interview_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_interview_ai/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository authRepository;

  HomeCubit(this.authRepository) : super(HomeInitial());

  Future<void> loadProfile() async {
    emit(HomeLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user == null) {
        emit(const HomeError('User not logged in'));
        return;
      }
      emit(HomeLoaded(user));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
