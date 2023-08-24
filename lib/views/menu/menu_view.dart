import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/textfield_components/my_passwordfield.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/menu/menu_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      backgroundColor: MyColors.greyMenuBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              showTopSection(context),
              // Expanded(
              //   child: ListView(
              //     children: [
              //       ListTile(
              //         leading: const Icon(
              //           Icons.chat_bubble_outline,
              //           color: Colors.white,
              //         ),
              //         title: const Text(MyStrings.menuPlaceholder,
              //             style: TextStyle(color: Colors.white)),
              //         onTap: () {
              //           _menuViewmodel.openChat();
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              buildChatList(),
              showBottomSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChatList() {
    return Expanded(
      child: FutureBuilder(
          future: _menuViewmodel.getCurrentUserChats(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapchot) {
            if (snapchot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  // shrinkWrap: true,
                  itemCount: snapchot.data?.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(snapchot.data?.docs[index].data()['title']),
                      onTap: () {
                        // TODO: chat id senden und chat state öffnen zu dem chat.
                        // ist in snapchat.data.docs (liste von chats) drin. Mit index iterieren.
                      },
                    );
                  });
            } 
            // else if (snapchot.connectionState == ConnectionState.waiting) {
            // }
              return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Column showTopSection(BuildContext context) {
    return Column(
      children: [
        showNewChatButton(context),
        const Divider(color: Colors.white),
      ],
    );
  }

  Column showBottomSection(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Colors.white),
        showCleanHistoryButton(context),
        showResetPasswordButton(context),
        showLogoutButton(context),
      ],
    );
  }

  ListTile showLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.logout_outlined,
        color: Colors.white,
      ),
      title: const Text(MyStrings.menuLogout,
          style: TextStyle(color: Colors.white)),
      onTap: () => {
        showConformationDialog(
            context,
            "Sure you want to log out?",
            "Logout",
            () => {
                  _menuViewmodel.logOut().then((value) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  })
                })
      },
    );
  }

  ListTile showResetPasswordButton(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.lock_reset_outlined,
        color: Colors.white,
      ),
      title: const Text(MyStrings.menuResetPassword,
          style: TextStyle(color: Colors.white)),
      onTap: () {
        showModalDialog(context, _menuViewmodel);
      },
    );
  }

  ListTile showCleanHistoryButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_outline, color: Colors.red),
      title: const Text(MyStrings.menuCleanHistory,
          style: TextStyle(color: Colors.red)),
      onTap: () {
        showConformationDialog(context, "Do you surely want to clear history",
            "clear history", () => {_menuViewmodel.cleanHistory()});
      },
    );
  }

  ListTile showNewChatButton(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      title: const Text(
        MyStrings.menuNewChat,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        // to set the chat state to default in chatViewmodel
        _menuViewmodel.createNewChat();
        // to close the drawer to get to the new chat.
        Navigator.pop(context);
      },
    );
  }

  showConformationDialog(BuildContext context, String confirmationMessage,
      String actionDescription, Function action) {
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
      child:
          Text(actionDescription, style: const TextStyle(color: Colors.white)),
      onPressed: () {
        action();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: const Color(0xff202123),
      title: Text(
        actionDescription,
        style: const TextStyle(color: Colors.white),
      ),
      content: Text(confirmationMessage,
          style: const TextStyle(color: Colors.white)),
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
              isLoading: snapshot.data ?? false,
            ),
          );
        });
  }
}
