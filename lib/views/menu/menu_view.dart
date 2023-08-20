import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/views/menu/menu_viewmodel.dart';
import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {
  MenuView({super.key});

  final MenuViewmodel _menuViewmodel = MenuViewmodel();

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
                      _menuViewmodel.resetPassword();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(MyStrings.menuLogout,
                        style: TextStyle(color: Colors.white)),
                    onTap: () => {
                      showConformationDialog(context)
                    },
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
      child: const Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        _menuViewmodel.logOut().then((value) {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text(
          "are you sure you would like to log out?"),
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
}

