import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, dynamic> userInfo = {
    'username': '',
    'email': '',
    'id': '',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final SharedPreferences prefs = snapshot.data!;

            final String? username = prefs.getString('user_username');
            final String? email = prefs.getString('user_email');
            final String? id = prefs.getString('user_id');

            userInfo['username'] = username;
            userInfo['email'] = email;
            userInfo['id'] = id;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Hello, ${userInfo['username']}'),
                  Text('Your email is ${userInfo['email']}'),
                  Text('Your id is ${userInfo['id']}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      prefs.remove('token');
                      prefs.remove('user_username');
                      prefs.remove('user_email');
                      prefs.remove('user_id');

                      GoRouter.of(context).go('/');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
