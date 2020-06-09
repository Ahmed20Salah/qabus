import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/user.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/localization.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  EditProfilePage(this.user);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phone;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildContent(context),
    );
  }

  void _submitForm(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();

    if (name == null ||
        email == null ||
        phone == null ||
        name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty) {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
      print('Form error');
      return null;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final AccountService auth = Provider.of<AccountService>(context);
      bool result =
          await auth.updateProfile(name, email, phone, widget.user.userId);
      setState(() {
        _isLoading = false;
      });
      if (result) {
        auth.updateUser(name, email, phone);
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
            _buildChangePictureWidget(context),
            _buildNameField(context),
            _buildEmailField(context),
            _buildPhoneField(context),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 25, right: 15),
              child: FlatButton(
                onPressed: _isLoading ? null : () => _submitForm(context),
                disabledColor: Theme.of(context).accentColor.withOpacity(0.5),
                color: Theme.of(context).accentColor,
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

  Widget _buildPhoneField(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 16),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.send,
        onEditingComplete: () => _submitForm(context),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('phone'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 16),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('email'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_phoneFocusNode);
        },
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: _nameController,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        textInputAction: TextInputAction.next,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('fullName'),
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePictureWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      // color: Colors.red,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: ((MediaQuery.of(context).size.width - 40) / 2) - 75,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 75,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
          Positioned(
            right: ((MediaQuery.of(context).size.width - 40) / 2) - 75,
            bottom: 15,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        color: Colors.grey,
                        spreadRadius: 0.2,
                        offset: Offset(0, 2))
                  ]),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        AppLocalizations.of(context).translate('editProfile'),
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}
