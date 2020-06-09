import 'package:flutter/material.dart';
import 'package:qabus/pages/auth/register.dart';
import 'package:qabus/pages/auth/sign_in_btn.dart';
import 'package:qabus/pages/auth/sign_in_social_btn.dart';
import 'package:qabus/pages/auth/sign_in_with_email.dart';
import 'package:qabus/services/localization.dart';

class AuthPage extends StatelessWidget {
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(AppLocalizations.of(context).translate('hello'),
                style:
                    Theme.of(context).textTheme.title.copyWith(fontSize: 50)),
            // _isLoading
            //     ? Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : Text(
            //         'Sign In',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            //       ),
            SizedBox(height: 48),
            // SignInWithSocialBtn(
            //   color: Colors.white,
            //   onPressed: () => {},
            //   textColor: Colors.black87,
            //   text: 'Sign in with Google',
            //   assetName: 'google-logo.png',
            // ),
            // SizedBox(height: 8),
            // SignInWithSocialBtn(
            //   color: Color(0xFF334D92),
            //   onPressed: () => {},
            //   textColor: Colors.white,
            //   text: 'Sign in with Facebook',
            //   assetName: 'facebook-logo.png',
            // ),
            // SizedBox(height: 8),
            SignInBtn(
              color: Colors.teal[700],
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignInWithEmailPage(),
                  ),
                );
              },
              textColor: Colors.white,
              text: AppLocalizations.of(context).translate('signInWithEmail'),
            ),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).translate('or'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            SignInBtn(
              color: Colors.lime[300],
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage(),
                  ),
                );
              },
              textColor: Colors.black,
              text: AppLocalizations.of(context).translate('registerAnAccount'),
            ),
          ],
        ),
      ),
    );
  }
}
