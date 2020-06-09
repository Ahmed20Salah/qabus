import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/pages/tabs.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/localization.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailfocusNode = FocusNode();
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

  TextField _buildEmailField(BuildContext context) {
    return TextField(
      focusNode: _emailfocusNode,
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
      onEditingComplete: _resetPassword,
    );
  }

  void _resetPassword() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text.trim();
    if (email.isEmpty ||
        email == null) {
      print('non valid form');
      return null;
    }
    try {
      bool result = await auth.forgotPassword(email);
      setState(() {
        _isLoading = false;
      });
      if (result) {
       Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      FocusScope.of(context).requestFocus(_emailfocusNode);
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
                  AppLocalizations.of(context).translate('forgotPassMainText'),
                  style:
                      Theme.of(context).textTheme.title.copyWith(fontSize: 35),
                ),
                Text(
                  AppLocalizations.of(context).translate('forgotPassHelpText'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 50),
                _buildEmailField(context),
                SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: FlatButton(
                    disabledColor: Theme.of(context).accentColor.withOpacity(0.5),
                    color: Theme.of(context).accentColor,
                    child: Text(
                      AppLocalizations.of(context).translate('resetPassword'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: _isLoading ? null : _resetPassword,
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
