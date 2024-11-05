import 'package:clothing_store/app/data/services/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            // Title and Subtitle
            Text(
              'Lorem Ipsum',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your style, your statement. Find the perfect fit today',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30),
            // Logo
            Image.asset(
              'assets/logo.png', // Ensure this image exists in your assets
              height: 200,
            ),
            SizedBox(height: 5),
            // Form Fields
            TextField(
              controller: controller.usernameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.phoneController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            // Register Button
            ElevatedButton(
              onPressed: () {
                controller.register();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            // Social Media Options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("atau"),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset(
                      'assets/google.png'), // Replace with actual Google logo
                  iconSize: 40,
                  onPressed: () {
                    controller.signInWithGoogle();
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Image.asset(
                      'assets/facebook.png'), // Replace with actual Facebook logo
                  iconSize: 40,
                  onPressed: () {
                    controller.signInWithFacebook();
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Image.asset(
                      'assets/apple.png'), // Replace with actual Apple logo
                  iconSize: 40,
                  onPressed: () {
                    controller.signInWithApple();
                  },
                ),
              ],
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    ));
  }
}
