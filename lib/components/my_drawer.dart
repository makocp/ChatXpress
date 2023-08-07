import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('New chat'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Delete history'),
                    onTap: () {},
                  ),
                  const Divider(),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 1'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 2'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: const Text('Chat History Item 3'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock_reset_outlined),
                    title: const Text('Reset password'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text('Logout'),
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
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
