import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/authentication/bloc/auth_bloc.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/sign_up_usecase.dart';
import '../../repositories/auth_repository.dart';
import '../../service/api_client.dart';
import '../../service/auth_services.dart';
import '../../service/token_storage.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // 🔐 storage
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage());

  // 🌐 dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // 🔗 api client
  getIt.registerLazySingleton<ApiClient>(
        () => ApiClient(getIt<Dio>(), getIt<TokenStorage>()),
  );

  // 📡 data source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(getIt<ApiClient>()),
  );

  // 📦 repository (ONLY IMPLEMENTATION)
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // ⚡ use case
  getIt.registerLazySingleton<SignUpUseCase>(
        () => SignUpUseCase(getIt<AuthRepository>()),
  );

  // 🧠 bloc
  getIt.registerFactory<AuthBloc>(
        () => AuthBloc(getIt<SignUpUseCase>()),
  );
}