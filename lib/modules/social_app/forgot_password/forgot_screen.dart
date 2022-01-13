import 'package:flutter/material.dart';
import 'package:scoial_app/modules/social_app/social_login/login_screen.dart';
import 'package:scoial_app/shared/components/components.dart';


class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            navigateTo(context, LoginScreen());
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              'Please enter your email address. You will receive a link to create a new ',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter your email",
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                color: Colors.amber,
                onPressed: () {},
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
