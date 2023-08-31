import 'package:flutter/material.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/textfield_components/my_passwordfield.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/menu/menu_viewmodel.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class BottomSheetView extends StatelessWidget with GetItMixin {
  BottomSheetView({Key? key}) : super(key: key);

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _repeatNewPasswordController =
      TextEditingController();

  final _menuViewModel = serviceContainer<MenuViewmodel>();

  @override
  Widget build(BuildContext context) {
    String changePasswordMessage =
        watchOnly((MenuViewmodel vm) => vm.changePasswordMessage);
    return Container(
      color: const Color(0xff202123),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildTitle(),
          _buildPasswordField(
              controller: _newPasswordController,
              labelText: MyStrings.enterNewPassword),
          _buildPasswordField(
              controller: _repeatNewPasswordController,
              labelText: MyStrings.repeatNewPassword),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Text(
              "* $changePasswordMessage",
              style: const TextStyle(color: Colors.white60),
            ),
          ),
          _buildChangePasswordButton(context)
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: MyPasswordfield(
        controller: controller,
        labelText: labelText,
        isError: false,
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Text(
        MyStrings.changePassword,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _menuViewModel.progressStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: MyButton(
            onPressed: () {
              _menuViewModel.updatePassword(_newPasswordController.text,
                  _repeatNewPasswordController.text);
            },
            buttonText: MyStrings.buttonChangePassword,
            isLoading: snapshot.data ?? false,
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 10,
          width: 100,
          color: Colors.white60,
        ),
      ),
    );
  }
}
