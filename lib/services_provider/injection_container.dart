import 'package:chatXpress/pages/chat/chat_page_model.dart';
import 'package:chatXpress/services/gpt.dart';
import 'package:get_it/get_it.dart';

final ServiceLocator = GetIt.instance;

void init(){

  // init external services: GPT/Firebase
  ServiceLocator.registerSingleton<ChatPageModel>(ChatPageModel());
  ServiceLocator.registerSingleton<Gpt>(Gpt());

}