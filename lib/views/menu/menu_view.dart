import 'package:chatXpress/assets/colors/my_colors.dart';
import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/menu_components/bottom_sheet_view.dart';
import 'package:chatXpress/services_provider/service_container.dart';
import 'package:chatXpress/views/menu/menu_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MenuView extends StatelessWidget with GetItMixin {
  MenuView({super.key});

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
              buildChatList(),
              showBottomSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // to build the chatlist in MenuView
  Widget buildChatList() {
    return Expanded(
      child: FutureBuilder(
          // gets all chats for the current user
          future: _menuViewmodel.getCurrentUserChats(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapchot) {
            if (snapchot.connectionState == ConnectionState.done) {
              // gets the length of the list
              int chatCount = snapchot.data!.docs.length;
              return ListView.builder(
                  itemCount: chatCount,
                  itemBuilder: (context, index) {
                    // gets the chattitle and chatid for the chat to load chat data with chatid, if clicked on it
                    String chatTitle =
                        snapchot.data!.docs[index].data()['title'];
                    String chatId = snapchot.data!.docs[index].id;
                    // builds a listtile for each chat
                    return ListTile(
                      leading: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                      ),
                      // contentPadding: const EdgeInsets.all(8.0),
                      title: Text(
                        chatTitle,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _menuViewmodel.openChat(chatId);
                        Navigator.pop(context);
                      },
                    );
                  });
            }
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

  Widget _buildBottomSheetContent(
      BuildContext context, MenuViewmodel menuViewModel) {
    return BottomSheetView();
  }
}
