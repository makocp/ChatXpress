import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff202123),
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
                    onTap: () {},
                  ),
                  const Divider(),
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
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_outline,color: Colors.red),
                    title: const Text('Delete history', style: TextStyle(color: Colors.red)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_reset_outlined,color: Colors.white,),
                    title: const Text('Reset password',style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined,color: Colors.white,),
                    title: const Text('Logout',style: TextStyle(color: Colors.white)),
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
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
