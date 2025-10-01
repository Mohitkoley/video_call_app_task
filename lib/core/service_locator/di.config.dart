// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/auth_repository_impl/auth_repository_impl.dart'
    as _i102;
import '../../features/auth/data/datasource/remote/auth_remote_datasource.dart'
    as _i757;
import '../../features/auth/domain/repository/auth_repository.dart' as _i961;
import '../../features/auth/domain/usecases/get_all_user.dart' as _i1071;
import '../../features/auth/domain/usecases/get_current_user.dart' as _i111;
import '../../features/auth/domain/usecases/sign_in.dart' as _i920;
import '../../features/auth/domain/usecases/sign_out.dart' as _i568;
import '../../features/auth/domain/usecases/sign_up.dart' as _i190;
import '../../features/auth/presentation/bloc/bloc/auth_bloc.dart' as _i137;
import '../../features/video_call/data/repository/call_repository_impl.dart'
    as _i198;
import '../../features/video_call/domain/repository/call_repository.dart'
    as _i721;
import '../../features/video_call/domain/usecase/end_call.dart' as _i784;
import '../../features/video_call/domain/usecase/start_call.dart' as _i814;
import '../../features/video_call/presentation/bloc/bloc/video_call_bloc.dart'
    as _i221;
import '../routes/app_router.dart' as _i629;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i629.AppRouter>(() => _i629.AppRouter());
    gh.lazySingleton<_i757.AuthRemoteDataSource>(
      () => _i757.AuthRemoteDataSourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i721.CallRepository>(
      () => _i198.CallRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i961.AuthRepository>(
      () => _i102.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i814.StartCall>(
      () => _i814.StartCall(gh<_i721.CallRepository>()),
    );
    gh.lazySingleton<_i1071.GetAllUsers>(
      () => _i1071.GetAllUsers(gh<_i961.AuthRepository>()),
    );
    gh.lazySingleton<_i568.SignOut>(
      () => _i568.SignOut(gh<_i961.AuthRepository>()),
    );
    gh.lazySingleton<_i111.GetCurrentUser>(
      () => _i111.GetCurrentUser(gh<_i961.AuthRepository>()),
    );
    gh.lazySingleton<_i920.SignIn>(
      () => _i920.SignIn(gh<_i961.AuthRepository>()),
    );
    gh.lazySingleton<_i190.SignUp>(
      () => _i190.SignUp(gh<_i961.AuthRepository>()),
    );
    gh.lazySingleton<_i137.AuthBloc>(
      () => _i137.AuthBloc(
        signInUseCase: gh<_i920.SignIn>(),
        signUpUseCase: gh<_i190.SignUp>(),
        signOutUseCase: gh<_i568.SignOut>(),
        getCurrentUserUseCase: gh<_i111.GetCurrentUser>(),
        getAllUsersUseCase: gh<_i1071.GetAllUsers>(),
      ),
    );
    gh.lazySingleton<_i221.VideoCallBloc>(
      () => _i221.VideoCallBloc(gh<_i814.StartCall>(), gh<_i784.EndCall>()),
    );
    return this;
  }
}
