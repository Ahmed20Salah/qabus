import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/localization.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;
  ChangePasswordPage(this.user);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FocusNode _newPassFocusNode = FocusNode();
  final FocusNode _newPassExtraFocusNode = FocusNode();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildContent(context),
    );
  }

  void _submitForm() async {
    final String oldPass = _oldPassController.text;
    final String newPass = _newPassController.text;
    final String confirmPass = _confirmPassController.text;

    if(oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty || newPass != confirmPass) {
      return null;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AccountService>(context);
      bool result = await auth.resetPassword(oldPass, newPass, widget.user.userId);
      setState(() {
        _isLoading = false;
      });
      if(result) {
        auth.logout();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildOldPassField(context),
            _buildNewPassField(context),
            _buildNewPassExtraField(context),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 25, right: 15),
              child: FlatButton(
                onPressed: _isLoading ? null : _submitForm,
                color: Theme.of(context).accentColor,
                disabledColor: Theme.of(context).accentColor.withOpacity(0.5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('save'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOldPassField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: _oldPassController,
        obscureText: true,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 16),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('oldPassword'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_newPassFocusNode);
        },
      ),
    );
  }

  Widget _buildNewPassField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: _newPassController,
        obscureText: true,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 16),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('newPassword'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        focusNode: _newPassFocusNode,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_newPassExtraFocusNode);
        },
      ),
    );
  }

  Widget _buildNewPassExtraField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: _confirmPassController,
        obscureText: true,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 16),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('confirmNewPassword'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        focusNode: _newPassExtraFocusNode,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        AppLocalizations.of(context).translate('changePassword'),
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}
