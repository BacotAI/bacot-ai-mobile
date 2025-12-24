import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_interview_ai/core/di/modules/bloc_module.dart';
import 'package:smart_interview_ai/core/di/modules/network_module.dart';
import 'package:smart_interview_ai/core/di/modules/repository_module.dart';
import 'package:smart_interview_ai/core/di/modules/router_module.dart';
import 'package:smart_interview_ai/core/di/modules/service_module.dart';

final sl = GetIt.instance;

abstract class Injection {
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');

    ServiceModule.init(sl);
    NetworkModule.init(sl);
    RouterModule.init(sl);
    RepositoryModule.init(sl);
    BlocModule.init(sl);
  }
}
