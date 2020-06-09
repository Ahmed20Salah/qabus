import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/localization.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
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

  TextField _buildNameField(BuildContext context) {
    return TextField(
      controller: _nameController,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        labelText: AppLocalizations.of(context).translate('name'),
        labelStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
    );
  }

  TextField _buildConfirmPasswordField() {
    return TextField(
      controller: _confirmPassController,
      focusNode: _confirmPasswordFocusNode,
      cursorColor: Colors.black,
      obscureText: true,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        labelText: AppLocalizations.of(context).translate('confirmPassword'),
        labelStyle: TextStyle(color: Colors.grey),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onEditingComplete: _register,
    );
  }

  TextField _buildPasswordField(BuildContext context) {
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
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
    );
  }

  TextField _buildEmailField(BuildContext context) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
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

  void _register() async {
    final String fullName = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPassController.text;

    if (password == null ||
        password.length < 6 ||
        (password != confirmPassword)) {
      return print('Passwords not valid');
    }
    if (fullName.isEmpty ||
        email.isEmpty ||
        fullName == null ||
        email == null) {
      return print('form not valid');
    }
    try {
      //TODO change category list
      User user = await auth.register(email, password);
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
                  AppLocalizations.of(context).translate('registerWithEmailTitle'),
                  style:
                      Theme.of(context).textTheme.title.copyWith(fontSize: 35),
                ),
                Text(
                  AppLocalizations.of(context).translate('registerWithEmailSubtitle'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 50),
                _buildNameField(context),
                _buildEmailField(context),
                _buildPasswordField(context),
                _buildConfirmPasswordField(),
                SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    disabledColor:
                        Theme.of(context).accentColor.withOpacity(0.5),
                    child: Text(
                      AppLocalizations.of(context).translate('register'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: _isLoading ? null : _register,
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
