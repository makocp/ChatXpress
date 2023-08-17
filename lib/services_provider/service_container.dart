import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services/toast_service.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:chatXpress/views/sign_in/sign_in_viewmodel.dart';
import 'package:get_it/get_it.dart';

final serviceContainer = GetIt.instance;

void initServiceLocator() {
  serviceContainer.registerLazySingleton<AuthService>(() => AuthService());
  serviceContainer.registerLazySingleton<GptService>(() => GptService());
  serviceContainer.registerLazySingleton<FirestoreService>(() => FirestoreService());
  serviceContainer.registerSingleton<ChatViewmodel>(ChatViewmodel());
  serviceContainer.registerLazySingleton<ToastService>(() => ToastService());
  serviceContainer.registerLazySingleton<SignInViewmodel>(() => SignInViewmodel());
}
