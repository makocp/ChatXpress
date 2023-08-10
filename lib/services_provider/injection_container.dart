import 'package:chatXpress/pages/chat/chat_page_model.dart';
import 'package:chatXpress/pages/sign_in/sing_in_page_model.dart';
import 'package:chatXpress/services/auth_service.dart';
import 'package:chatXpress/services/gpt.dart';
import 'package:get_it/get_it.dart';

final ServiceLocator = GetIt.instance;

void init(){
  // init external services: GPT/Firebase
  ServiceLocator.registerSingleton<ChatPageModel>(ChatPageModel());
  ServiceLocator.registerSingleton<Gpt>(Gpt());
}

void initSignInService(){
  ServiceLocator.registerSingleton<AuthService>(AuthService());
  ServiceLocator.registerSingleton<SignInPageModel>(SignInPageModel());
}

void disposeSignInService(){
  ServiceLocator.unregister<AuthService>();
  ServiceLocator.unregister<SignInPageModel>();

}