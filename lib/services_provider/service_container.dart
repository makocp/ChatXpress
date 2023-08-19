import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/firestore_service.dart';
import 'package:chatXpress/services/gpt_service.dart';
import 'package:chatXpress/services/toast_service.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:chatXpress/views/forgot_password/forgot_password_viewmodel.dart';
import 'package:chatXpress/views/sign_in/sign_in_viewmodel.dart';
import 'package:chatXpress/views/sign_up/sign_up_viewmodel.dart';
import 'package:get_it/get_it.dart';

final serviceContainer = GetIt.instance;

void initServiceLocator() {
  serviceContainer.registerSingleton<AuthService>(AuthService());
  serviceContainer.registerSingleton<GptService>(GptService());
  serviceContainer.registerSingleton<FirestoreService>(FirestoreService());
  serviceContainer.registerSingleton<ChatViewmodel>(ChatViewmodel());
  serviceContainer.registerSingleton<ToastService>(ToastService());
  serviceContainer.registerLazySingleton<SignInViewmodel>(() => SignInViewmodel());
  serviceContainer.registerLazySingleton<ForgotPasswordViewmodel>(() => ForgotPasswordViewmodel());
  serviceContainer.registerLazySingleton<SignUpViewmodel>(() => SignUpViewmodel());
}
