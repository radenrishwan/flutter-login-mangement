import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:login_management/constant.dart';
import 'package:login_management/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode passwordNode = FocusNode(
    debugLabel: 'password',
  );

  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  var errorMessage = '';

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: 'juju');
    passwordController = TextEditingController(text: '123123');
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
                keyboardType: TextInputType.name,
                autofocus: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(passwordNode);
                },
                validator: (value) {
                  if (value!.length < 3) {
                    return 'Username must be at least 3 characters';
                  }

                  if (value.length > 20) {
                    return 'Username must be at most 20 characters';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                focusNode: passwordNode,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                // obscureText: true,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).push('/register'),
                    child: const Text('Register'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final preps = await SharedPreferences.getInstance();

                      try {
                        await login(usernameController.text, passwordController.text).then((value) {
                          preps.setString('token', value.token);
                          preps.setString('user_id', value.id);
                          preps.setString('user_email', value.email);
                          preps.setString('user_username', value.username);

                          GoRouter.of(context).go('/home');
                        });
                      } catch (err) {
                        log(err.toString());
                        setState(() {
                          errorMessage = err.toString();
                        });
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Text(errorMessage),
            ],
          ),
        ),
      ),
    );
  }

  Future<User> login(String username, String password) async {
    final response = await http.post(Uri.parse('$endpoint/user/login'), body: {
      'username': username.trim(),
      'password': password.trim(),
    });

    final result = jsonDecode(response.body) as Map<String, dynamic>;

    if (result['code'] == 200) {
      return User.fromJson(result['data']);
    }

    throw Exception(result['data']);
  }
}
