import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/pages/auth/forgot_password.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/localization.dart';

class SignInWithEmailPage extends StatefulWidget {
  @override
  _SignInWithEmailPageState createState() => _SignInWithEmailPageState();
}

class _SignInWithEmailPageState extends State<SignInWithEmailPage> {
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  AccountService auth;

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
    );
  }

  TextField _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      cursorColor: Colors.black,
      obscureText: true,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        labelText: AppLocalizations.of(context).translate('password'),
        labelStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.send,
      onEditingComplete: _login,
    );
  }

  TextField _buildEmailField(BuildContext context) {
    return TextField(
      controller: _emailController,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        labelText: AppLocalizations.of(context).translate('email'),
        labelStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    if (email.isEmpty ||
        email == null ||
        password.isEmpty ||
        password == null) {
      print('non valid form');
      return null;
    }
    try {
      User user = await auth.login(email, password);
      setState(() {
        _isLoading = false;
      });
      if (user != null) {
        Navigator.of(context).pop();
         Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      FocusScope.of(context).requestFocus(_passwordFocusNode);
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AccountService>(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('signInWithEmailTitle'),
                  style:
                      Theme.of(context).textTheme.title.copyWith(fontSize: 35),
                ),
                Text(
                  AppLocalizations.of(context).translate('signInWithEmailSubtitle'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 50),
                _buildEmailField(context),
                _buildPasswordField(),
                SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: FlatButton(
                    disabledColor: Theme.of(context).accentColor.withOpacity(0.5),
                    color: Theme.of(context).accentColor,
                    child: Text(
                      AppLocalizations.of(context).translate('loginText'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  child: FlatButton(
                    child: Text(
                      AppLocalizations.of(context).translate('forgotPassword'),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => ForgotPasswordPage(),),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
