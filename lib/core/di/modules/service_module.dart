import 'package:get_it/get_it.dart';
import 'package:logarte/logarte.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_interview_ai/core/services/interview_recorder_service.dart';

abstract class ServiceModule {
  static void init(GetIt sl) {
    sl.registerLazySingleton<InterviewRecorderService>(
      () => InterviewRecorderService(),
    );

    sl.registerLazySingleton<Logarte>(
      () => Logarte(
        password: 'tulkun-tul',
        onShare: (content) {
          SharePlus.instance.share(
            ShareParams(
              text: content,
              title: 'Network Request',
              excludedCupertinoActivities: [CupertinoActivityType.airDrop],
            ),
          );
        },
        onExport: (allLogs) {
          SharePlus.instance.share(
            ShareParams(
              text: allLogs,
              title: 'Network Request',
              excludedCupertinoActivities: [CupertinoActivityType.airDrop],
            ),
          );
        },
      ),
    );
  }
}
