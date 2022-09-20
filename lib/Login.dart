import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => Screen();
}

class Screen extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Welcome to Your Pharmacy',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: Text(
                'Login to go!.',
                style: TextStyle(fontSize: 25, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              padding: const EdgeInsets.all(8),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: nameController,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 10),
            /*TextButton(
              onPressed: () {
              },
              child: const Text(
                'Forgot Password',
              ),
            ),*/
            Container(
                height: 55,
                padding: const EdgeInsets.fromLTRB(11, 7, 11, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    try {
                      final user = await _auth
                          .signInWithEmailAndPassword(
                              email: email, password: password)
                          .catchError((onError) {
                        FirebaseAuthException exception = onError;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(exception.message!)));
                      });
                      Navigator.pushNamed(context, 'RegisterScreen');
                      if (user != null) {
                        Navigator.pushNamed(context, 'bottomNavigationBar');
                      }
                    } catch (e) {}
                    ;
                  },
                )),
            Container(
              child: Row(
                children: <Widget>[
                  const Text('Don\'t have account?'),
                  TextButton(
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'RegisterScreen');
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ));
  }
}
