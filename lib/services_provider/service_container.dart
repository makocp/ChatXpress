import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:get_it/get_it.dart';

final serviceContainer = GetIt.instance;

void initServiceLocator() {
  serviceContainer.registerLazySingleton<AuthService>(() => AuthService());
  serviceContainer.registerLazySingleton<GptService>(() => GptService());
  serviceContainer.registerLazySingleton<FirestoreService>(() => FirestoreService());
}
