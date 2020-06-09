import 'package:flutter/material.dart';

class AddOfferPage extends StatefulWidget {
  @override
  _AddOfferPageState createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  final FocusNode _descriptionFocusNode = FocusNode();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _dropdownValue;
  List<String> _companyValues = ['Webzone', 'Al Mauna', 'Water Company'];

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        'Add Offer',
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String text,
      [FocusNode currentNode, FocusNode nextNode]) {
    return TextField(
      focusNode: currentNode,
      cursorColor: Colors.black,
      style: TextStyle(fontSize: 16),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      onEditingComplete: nextNode == null
          ? () {}
          : () {
              FocusScope.of(context).requestFocus(nextNode);
            },
    );
  }

  void _onStartDateTapped() async {
    FocusScope.of(context).requestFocus(FocusNode());

    _startDate = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
            child: child,
            data: ThemeData(
                primaryColor: Theme.of(context).accentColor,
                accentColor: Colors.black),
          );
        });
    setState(() {});
  }

  void _onEndDateTapped() async {
    FocusScope.of(context).requestFocus(FocusNode());

    _endDate = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: _startDate.add(Duration(days: 1)),
        firstDate: _startDate,
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
            child: child,
            data: ThemeData(
                primaryColor: Theme.of(context).accentColor,
                accentColor: Colors.black),
          );
        });
    setState(() {});
  }

  Widget _buildStartDate() {
    return FlatButton(
      onPressed: _onStartDateTapped,
      padding: EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Start Date',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 11)),
            Text(
              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEndDate() {
    return FlatButton(
      onPressed: _onEndDateTapped,
      padding: EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('End Date',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 11)),
            Text(
              '${_endDate.day}/${_endDate.month}/${_endDate.year}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyDropDown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Company',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          DropdownButton<String>(
            hint: Text('select Company'),
            isExpanded: true,
            value: _dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.8),
            underline: Container(
              height: 1,
              color: Colors.grey,
            ),
            onChanged: (String newValue) {
              setState(() {
                _dropdownValue = newValue;
              });
            },
            items: _companyValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Cover Image',
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {},
          child: Image(
            image: AssetImage('assets/images/placeholder.png'),
          ),
        )
      ],
    );
  }

  Widget _buildSaveBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          'SAVE',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        color: Theme.of(context).accentColor,
        minWidth: MediaQuery.of(context).size.width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTextField(
                    context, 'Heading', null, _descriptionFocusNode),
                _buildTextField(
                    context, 'Description', _descriptionFocusNode, null),
                _buildStartDate(),
                _buildEndDate(),
                _buildCompanyDropDown(),
                _buildCoverImage(),
                _buildSaveBtn(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
