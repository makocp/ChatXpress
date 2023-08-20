import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/textfield_components/my_passwordfield.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/menu/menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MenuView extends StatelessWidget with GetItMixin {
  MenuView({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatNewPasswordController =
      TextEditingController();
  final _menuViewmodel = serviceContainer<MenuViewmodel>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff202123),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    title: const Text(
                      MyStrings.menuNewChat,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _menuViewmodel.createNewChat();
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                      ),
                      title: const Text(MyStrings.menuPlaceholder,
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        _menuViewmodel.openChat();
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.delete_outline, color: Colors.red),
                    title: const Text(MyStrings.menuCleanHistory,
                        style: TextStyle(color: Colors.red)),
                    onTap: () {
                      _menuViewmodel.cleanHistory();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.lock_reset_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(MyStrings.menuResetPassword,
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      showModalDialog(context, _menuViewmodel);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(MyStrings.menuLogout,
                        style: TextStyle(color: Colors.white)),
                    onTap: () => {showConformationDialog(context)},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showConformationDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: MyColors.greenDefaultColorDark),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(MyColors.redForDeleteButton)),
      child: const Text("Log out", style: TextStyle(color: Colors.white)),
      onPressed: () {
        _menuViewmodel.logOut().then((value) {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color(0xff202123),
      title: const Text(
        "Log out",
        style: TextStyle(color: Colors.white),
      ),
      content: const Text("Sure you want to log out?",
          style: TextStyle(color: Colors.white)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showModalDialog(BuildContext context, MenuViewmodel menuViewModel) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => _buildBottomSheetContent(context, menuViewModel),
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
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomSheetContent(
      BuildContext context, MenuViewmodel menuViewModel) {
    return Container(
      color: const Color(0xff202123),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildTitle(),
          _buildPasswordField(
            controller: newPasswordController,
            labelText: "enter new password",
          ),
          _buildPasswordField(
            controller: repeatNewPasswordController,
            labelText: "repeat new password",
          ),
          _buildChangePasswordButton(menuViewModel),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 8),
      child: MyPasswordfield(
        controller: controller,
        labelText: labelText,
        isError: false,
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15, 30, 15, 8),
      child: Text(
        "change password",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton(MenuViewmodel menuViewModel) {
    return StreamBuilder<bool>(
      stream: _menuViewmodel.progressStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 8),
          child: MyButton(
            onPressed: () {
              menuViewModel.updatePassword(newPasswordController.text);
            },
            buttonText: 'change password',
            // 2 stunden gebraucht um auf diese Zeile zu kommen :)
            // kannst du mich bitte umbringen? danke
            isLoading: snapshot.data ?? false,
          ),
        );
      }
    );
  }
}
