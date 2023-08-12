import 'package:chatXpress/pages/chat/chat_page_model.dart';
import 'package:chatXpress/pages/forgot_password/forgot_password_page_model.dart';
import 'package:chatXpress/pages/sign_in/sign_in_page_model.dart';
import 'package:chatXpress/pages/sign_up/sign_up_page_model.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/gpt.dart';
import 'package:get_it/get_it.dart';

final ServiceLocator = GetIt.instance;

void init() {
  ServiceLocator.registerSingleton<AuthService>(AuthService());
  ServiceLocator.registerSingleton<Gpt>(Gpt());
}
