import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/button_components/my_button.dart';
import 'package:chatXpress/components/textfield_components/my_passwordfield.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/chat/chat_viewmodel.dart';
import 'package:chatXpress/views/menu/menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MenuView extends StatelessWidget with GetItMixin {
  MenuView({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatNewPasswordController =
      TextEditingController();
  final _menuViewmodel = serviceContainer<MenuViewmodel>();
  final _chatViewmodel = serviceContainer<ChatViewmodel>();

  @override
  Widget build(BuildContext context) {
    final bool isLoadingChats =
        watchOnly((ChatViewmodel vm) => vm.isLoadingChats);
    return Drawer(
      backgroundColor: MyColors.greyMenuBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              showTopSection(context),
              buildUserChats(isLoadingChats),
              showBottomSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserChats(bool isLoadingChats) {
    return Expanded(
        child: StreamBuilder(
      stream: _chatViewmodel.userchatStream,
      initialData: _chatViewmodel.currentUserchats,
      builder: (context, snapshot) {
        // no if statement for snapshot.hasdata needed -> initialData -> always true.
        if (!isLoadingChats) {
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                String chatId = snapshot.data![index].chatId;
                String chatTitle = snapshot.data![index].title;
                return ListTile(
                  leading: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                  ),
                  title: Text(
                    chatTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _menuViewmodel.openChat(chatId);
                    Navigator.pop(context);
                  },
                );
              },
            );
          } else {
            return const Center(
                child: Text('No chats created yet.',
                    style: TextStyle(
                      color: Colors.grey,
                    )));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
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
        showDeleteHistoryButton(context),
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
            MyStrings.logOutConfirmationString,
            MyStrings.logOut,
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
      title: const Text(MyStrings.changePassword,
          style: TextStyle(color: Colors.white)),
      onTap: () {
        showModalDialog(context, _menuViewmodel);
      },
    );
  }

  ListTile showDeleteHistoryButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_outline, color: Colors.red),
      title: const Text(MyStrings.menuDeleteHistory,
          style: TextStyle(color: Colors.red)),
      onTap: () {
        showConformationDialog(
            context,
            MyStrings.menuDeleteHistoryText,
            MyStrings.menuDeleteHistoryTitle,
            () => {_menuViewmodel.deleteHistory()});
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
        _menuViewmodel.openNewChat();
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
        MyStrings.cancel,
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
        Navigator.pop(context);
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
            labelText: MyStrings.enterNewPassword,
          ),
          _buildPasswordField(
            controller: repeatNewPasswordController,
            labelText: MyStrings.repeatNewPassword,
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
        MyStrings.changePassword,
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
              buttonText: MyStrings.buttonChangePassword,
              isLoading: snapshot.data ?? false,
            ),
          );
        });
  }
}
