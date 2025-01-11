import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/helpers/shared_preference_manager.dart';
import 'package:myapp/repositories/api/api_user_data_repository.dart';
import 'package:myapp/repositories/contracts/abs_api_moment_repository.dart';
import '../../repositories/api/api_moment_repository.dart';
import '../../repositories/api/api_upload_repository.dart';
import '../../repositories/contracts/abs_api_upload_repository.dart';
import '../../repositories/contracts/abs_api_user_data_repository.dart';
import '../../repositories/contracts/abs_auth_repository.dart';
import '../../repositories/contracts/abs_moment_repository.dart';
import '../../repositories/databases/db_moment_repository.dart';

import '../../repositories/api/api_auth_repository.dart';

final spm = SharedPreferencesManager();
final activeUserId = spm.getString(SharedPreferencesManager.keyActiveUserId);

final repositoryProvider = [
  RepositoryProvider<AbsAuthRepository>(
    create: (context) => ApiAuthRepository(),
  ),
  RepositoryProvider<AbsMomentRepository>(
    create: (context) => DbMomentRepository(),
  ),
  RepositoryProvider<AbsApiUserDataRepository>(
    create: (context) => ApiUserDataRepository(activeUserId),
  ),
  RepositoryProvider<AbsApiMomentRepository>(
    create: (context) => ApiMomentRepository(),
  ),
  RepositoryProvider<AbsApiUploadRepository>(
    create: (context) => ApiUploadRepository(),
  ),
];
