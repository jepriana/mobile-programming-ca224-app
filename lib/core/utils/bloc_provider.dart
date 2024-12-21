import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/views/authentication/bloc/authentication_bloc.dart';
import 'package:myapp/views/user/bloc/user_data_bloc.dart';

import '../../repositories/contracts/abs_api_user_data_repository.dart';
import '../../repositories/contracts/abs_auth_repository.dart';
import '../../repositories/contracts/abs_moment_repository.dart';
import '../../views/moment/bloc/moment_bloc.dart';

final blocProviders = [
  BlocProvider<AuthenticationBloc>(
    create: (context) => AuthenticationBloc(context.read<AbsAuthRepository>()),
  ),
  BlocProvider<MomentBloc>(
    create: (context) => MomentBloc(context.read<AbsMomentRepository>()),
  ),
  BlocProvider<UserDataBloc>(
    create: (context) => UserDataBloc(context.read<AbsApiUserDataRepository>()),
  ),
];
