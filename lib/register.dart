import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:login_management/constant.dart';
import 'package:login_management/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode passwordNode = FocusNode(
    debugLabel: 'password',
  );
  final FocusNode emailNode = FocusNode(
    debugLabel: 'email',
  );

  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController emailController;

  var errorMessage = '';

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Screen'),
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
                  FocusScope.of(context).requestFocus(emailNode);
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: emailNode,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(passwordNode);
                },
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                focusNode: passwordNode,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await register(usernameController.text, passwordController.text, emailController.text).then(
                          (value) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Register Success'),
                                content: const Text('Register Success'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        GoRouter.of(context).go('/');
                                      },
                                      child: const Text('OK'))
                                ],
                              ),
                            );
                          },
                        );
                      } catch (err) {
                        log(err.toString());
                        setState(() {
                          errorMessage = err.toString();
                        });
                      }
                    },
                    child: const Text('Register'),
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

  Future<User> register(String username, String password, String email) async {
    final response = await http.post(Uri.parse('$endpoint/user/register'), body: {
      'username': username.trim(),
      'password': password.trim(),
      'email': email.trim(),
    });

    final result = jsonDecode(response.body) as Map<String, dynamic>;

    if (result['code'] == 201) {
      return User.fromJson(result['data']);
    }

    throw Exception(result['data']);
  }
}
