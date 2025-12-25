// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logarte/logarte.dart' as _i855;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:smart_interview_ai/app/router/app_router.dart' as _i1001;
import 'package:smart_interview_ai/app/router/auth_guard.dart' as _i588;
import 'package:smart_interview_ai/application/auth/auth_bloc.dart' as _i521;
import 'package:smart_interview_ai/application/on_interview/on_interview_bloc.dart'
    as _i452;
import 'package:smart_interview_ai/application/pre_interview/pre_interview_bloc.dart'
    as _i25;
import 'package:smart_interview_ai/application/sample/sample_bloc.dart'
    as _i589;
import 'package:smart_interview_ai/core/di/modules/service_module.dart'
    as _i668;
import 'package:smart_interview_ai/core/network/api_client.dart' as _i805;
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart'
    as _i401;
import 'package:smart_interview_ai/domain/audio_input/audio_repository.dart'
    as _i257;
import 'package:smart_interview_ai/domain/auth/auth_repository.dart' as _i805;
import 'package:smart_interview_ai/domain/pre_interview/repositories/pre_interview_repository.dart'
    as _i280;
import 'package:smart_interview_ai/domain/sample/repositories/sample_repository.dart'
    as _i161;
import 'package:smart_interview_ai/infrastructure/audio_input/repositories/audio_repository_impl.dart'
    as _i622;
import 'package:smart_interview_ai/infrastructure/audio_input/whisper_service.dart'
    as _i1049;
import 'package:smart_interview_ai/infrastructure/auth/auth_repository_impl.dart'
    as _i787;
import 'package:smart_interview_ai/infrastructure/pre_interview/repositories/pre_interview_repository_impl.dart'
    as _i272;
import 'package:smart_interview_ai/infrastructure/sample/repositories/sample_repository_impl.dart'
    as _i993;
import 'package:smart_interview_ai/infrastructure/smart_camera/services/face_detector_service.dart'
    as _i165;
import 'package:smart_interview_ai/infrastructure/smart_camera/services/object_detector_service.dart'
    as _i254;
import 'package:smart_interview_ai/infrastructure/smart_camera/services/pose_detector_service.dart'
    as _i548;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final serviceModule = _$ServiceModule();
    gh.lazySingleton<_i116.GoogleSignIn>(() => serviceModule.googleSignIn);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => serviceModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i855.Logarte>(() => serviceModule.logarte);
    gh.lazySingleton<_i588.AuthGuard>(() => serviceModule.authGuard);
    gh.lazySingleton<_i401.InterviewRecorderService>(
      () => _i401.InterviewRecorderService(),
    );
    gh.lazySingleton<_i1049.WhisperService>(() => _i1049.WhisperService());
    gh.lazySingleton<_i165.FaceDetectorService>(
      () => _i165.FaceDetectorService(),
    );
    gh.lazySingleton<_i254.ObjectDetectorService>(
      () => _i254.ObjectDetectorService(),
    );
    gh.lazySingleton<_i548.PoseDetectorService>(
      () => _i548.PoseDetectorService(),
    );
    gh.lazySingleton<_i280.PreInterviewRepository>(
      () => _i272.PreInterviewRepositoryImpl(),
    );
    gh.lazySingleton<_i805.AuthRepository>(
      () => _i787.AuthRepositoryImpl(
        gh<_i116.GoogleSignIn>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i1001.AppRouter>(
      () => serviceModule.appRouter(gh<_i588.AuthGuard>()),
    );
    gh.factory<_i25.PreInterviewBloc>(
      () => _i25.PreInterviewBloc(gh<_i280.PreInterviewRepository>()),
    );
    gh.factory<_i452.OnInterviewBloc>(
      () => _i452.OnInterviewBloc(
        gh<_i401.InterviewRecorderService>(),
        gh<_i1049.WhisperService>(),
      ),
    );
    gh.factory<_i521.AuthBloc>(
      () => _i521.AuthBloc(gh<_i805.AuthRepository>()),
    );
    gh.lazySingleton<_i805.ApiClient>(
      () => serviceModule.apiClient(gh<_i855.Logarte>()),
    );
    gh.lazySingleton<_i161.SampleRepository>(
      () => _i993.SampleRepositoryImpl(apiClient: gh<_i805.ApiClient>()),
    );
    gh.lazySingleton<_i257.AudioRepository>(
      () => _i622.AudioRepositoryImpl(gh<_i805.ApiClient>()),
    );
    gh.factory<_i589.SampleBloc>(
      () => _i589.SampleBloc(gh<_i161.SampleRepository>()),
    );
    return this;
  }
}

class _$ServiceModule extends _i668.ServiceModule {}
