import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todak_assessment/screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/Todak_lightmode.png',
                  height: 200,
                  width: 100,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                color: CupertinoColors.black,
                onPressed: () {
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  if (username == '' && password == '') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Invalid username or password'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
