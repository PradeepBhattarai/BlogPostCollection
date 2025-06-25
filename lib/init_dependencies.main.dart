part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;


Future<void> initDependencies() async {
  // Required for Hive and Supabase
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
  );

  // Initialize Hive
  Hive.init((await getApplicationDocumentsDirectory()).path);

  // 🛠️ FIX: Open the 'blogs' box BEFORE registering it
  final blogBox = await Hive.openBox('blogs');

  // Register Supabase client
  serviceLocator.registerLazySingleton(() => supabase.client);

  // ✅ Register the already opened Hive box
  serviceLocator.registerLazySingleton(() => blogBox);

  serviceLocator.registerFactory(() => InternetConnection());

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );

  // Feature modules
  _initAuth();
  _initBlog();
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(()=>SignOut(serviceLocator()))
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        signOut: serviceLocator(),
        
      ),
    );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),

    );
}