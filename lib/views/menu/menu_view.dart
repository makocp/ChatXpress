import 'package:chatXpress/views/menu/menu_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                      'New chat',
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
                      title: const Text('Flutter Development',
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
                    title: const Text('Clean history',
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
                    title: const Text('Reset password',
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
                    title: const Text('Logout',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _menuViewmodel.logOut().then((value) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      });
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
}
