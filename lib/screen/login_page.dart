import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/main_page.dart';
import 'package:flutter_app/screen/register_page.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final TextEditingController _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32.0),
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  // image: const DecorationImage(
                  //   image: AssetImage('assets/images/logo.png'),
                  //   fit: BoxFit.fill,
                  // ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email không được để trống';
                  }
                  if (!value.contains('@gmail.com')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  icon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mật khẩu không được để trống';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async{
                  try {
                    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    // Navigate to the main page or perform other actions after successful sign-in
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  } catch (e) {
                    print('Sign-in failed: $e');
                    // Handle sign-in failure, such as displaying an error message
                  }
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterPage()),
                    );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Continue with Google',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.abc),
                label: const Text('Sign In with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
