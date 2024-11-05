import 'package:flutter/material.dart';
import 'package:quiz/Home.dart';
import 'package:quiz/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: 400,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade50,
                    filled: true,
                    labelText: 'Username',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Màu viền
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent), // Màu viền
                      ),
                    labelStyle: TextStyle(color: Colors.orange.shade500)
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade50,
                    filled: true,
                    labelText: 'Password',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Màu viền
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent), // Màu viền
                    ),
                    labelStyle: TextStyle(color: Colors.orange.shade500)
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}