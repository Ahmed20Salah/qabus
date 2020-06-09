import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qabus/modals/business.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/explore_service.dart';
import 'package:qabus/pages/profile/listing_form_ctrls.dart';
import 'package:qabus/services/localization.dart';

class ListingFormPage extends StatefulWidget {
  final String businessId;

  ListingFormPage({this.businessId});

  @override
  _ListingFormPageState createState() => _ListingFormPageState();
}

class _ListingFormPageState extends State<ListingFormPage> {
  List<ListingField> listingFields = [];
  bool hasCarParking = false;
  bool hasWifi = false;
  bool hasPrayerRoom = false;
  bool hasWheelChair = false;
  bool hasCreditCard = false;
  bool hasAllTimeService = false;
  int currentStep = 0;
  bool isLoading = false;
  bool isLoadedOnce = false;
  File backgroundImage;
  File profileImage;

  List<ListingField> getListingsFields() {
    return [
      ListingField(
          controller: nameCtrl, focusNode: nameFocusNode, hintText: AppLocalizations.of(context).translate('name')),
      ListingField(
          controller: nameArCtrl,
          focusNode: nameArFocusNode,
          hintText: AppLocalizations.of(context).translate('nameInArabic')),
      ListingField(
          controller: descriptionCtrl,
          focusNode: descriptionFocusNode,
          hintText: AppLocalizations.of(context).translate('description')),
      ListingField(
          controller: descriptionArCtrl,
          focusNode: descriptionArFocusNode,
          hintText: AppLocalizations.of(context).translate('descriptionInArabic')),
      ListingField(
          controller: categoryCtrl,
          focusNode: categoryFocusNode,
          hintText: AppLocalizations.of(context).translate('category')),
      ListingField(
          controller: addressCtrl,
          focusNode: addressFocusNode,
          hintText: AppLocalizations.of(context).translate('address')),
      ListingField(
          controller: addressArCtrl,
          focusNode: addressArFocusNode,
          hintText: AppLocalizations.of(context).translate('addressInArabic')),
      ListingField(
          controller: latCtrl, focusNode: latFocusNode, hintText: AppLocalizations.of(context).translate('latitude')),
      ListingField(
          controller: lngCtrl, focusNode: lngFocusNode, hintText: AppLocalizations.of(context).translate('longitude')),
      ListingField(
          controller: phoneCtrl, focusNode: phoneFocusNode, hintText: AppLocalizations.of(context).translate('phone')),
      ListingField(
          controller: taglineCtrl,
          focusNode: taglineFocusNode,
          hintText: AppLocalizations.of(context).translate('tagline')),
      ListingField(
          controller: taglineArCtrl,
          focusNode: taglineArFocusNode,
          hintText: AppLocalizations.of(context).translate('taglineInArabic')),
      ListingField(
          controller: websiteCtrl,
          focusNode: websiteFocusNode,
          hintText: AppLocalizations.of(context).translate('website')),
      ListingField(
          controller: emailCtrl, focusNode: emailFocusNode, hintText: AppLocalizations.of(context).translate('email')),
      ListingField(
          controller: areaCtrl, focusNode: areaFocusNode, hintText: AppLocalizations.of(context).translate('area')),
      ListingField(
          controller: locationCtrl,
          focusNode: locationFocusNode,
          hintText: AppLocalizations.of(context).translate('location')),
      ListingField(
          controller: mondayCtrl,
          focusNode: mondayFocusNode,
          hintText: AppLocalizations.of(context).translate('monday')),
      ListingField(
          controller: tuesdayCtrl,
          focusNode: tuesdayFocusNode,
          hintText: AppLocalizations.of(context).translate('tuesday')),
      ListingField(
          controller: wednesdayCtrl,
          focusNode: wednesdayFocusNode,
          hintText: AppLocalizations.of(context).translate('wednesday')),
      ListingField(
          controller: thursdayCtrl,
          focusNode: thursdayFocusNode,
          hintText: AppLocalizations.of(context).translate('thursday')),
      ListingField(
          controller: fridayCtrl,
          focusNode: fridayFocusNode,
          hintText: AppLocalizations.of(context).translate('friday')),
      ListingField(
          controller: saturdayCtrl,
          focusNode: saturdayFocusNode,
          hintText: AppLocalizations.of(context).translate('saturday')),
      ListingField(
          controller: sundayCtrl,
          focusNode: sundayFocusNode,
          hintText: AppLocalizations.of(context).translate('sunday')),
      ListingField(
          controller: facebookCtrl,
          focusNode: facebookFocusNode,
          hintText: 'Facebook'),
      ListingField(
          controller: instagramCtrl,
          focusNode: instagramFocusNode,
          hintText: 'Instagram'),
      ListingField(
          controller: linkedinCtrl,
          focusNode: linkedinFocusNode,
          hintText: 'LinkedIn'),
      ListingField(
          controller: twitterCtrl,
          focusNode: twitterFocusNode,
          hintText: 'Twitter'),
      ListingField(
          controller: youtubeCtrl,
          focusNode: youtubeFocusNode,
          hintText: 'Youtube'),
    ];
  }

  List<Step> _buildSteps(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text(AppLocalizations.of(context).translate('details')),
        content: Column(children: getTextFields(0, 16, context)),
      ),
      Step(
        title: Text(AppLocalizations.of(context).translate('facilities')),
        content: Column(children: getCheckBoxes()),
      ),
      Step(
        title: Text(AppLocalizations.of(context).translate('workingHours')),
        content: Column(children: getTextFields(16, 23, context)),
      ),
    ];
    if (widget.businessId == null) {
      steps.add(
        Step(
          title: Text(AppLocalizations.of(context).translate('socialMediaLinks')),
          content: Column(children: getTextFields(23, 28, context)),
        ),
      );
      steps.add(Step(
        title: Text(AppLocalizations.of(context).translate('images')),
        content: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                File image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  backgroundImage = image;
                });
              },
              child: backgroundImage != null
                  ? Image.file(backgroundImage)
                  : Image.asset(
                      'assets/images/cover.png',
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            GestureDetector(
              onTap: () async {
                File image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  profileImage = image;
                });
              },
              child: profileImage != null
                  ? Image.file(profileImage)
                  : Image.asset(
                      'assets/images/cover.png',
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        ),
      ));
    }
    return steps;
  }

  List<CheckboxListTile> getCheckBoxes() {
    List<CheckboxListTile> checkboxes = [
      CheckboxListTile(
        title: Text(AppLocalizations.of(context).translate('carParking')),
        value: hasCarParking,
        onChanged: (bool value) {
          setState(() {
            hasCarParking = value;
          });
        },
      ),
      CheckboxListTile(
        title: Text(AppLocalizations.of(context).translate('wifi')),
        value: hasWifi,
        onChanged: (bool value) {
          setState(() {
            hasWifi = value;
          });
        },
      ),
      CheckboxListTile(
        title: Text(AppLocalizations.of(context).translate('prayerRoom')),
        value: hasPrayerRoom,
        onChanged: (bool value) {
          setState(() {
            hasPrayerRoom = value;
          });
        },
      ),
      CheckboxListTile(
        title: Text(AppLocalizations.of(context).translate('wheelChair')),
        value: hasWheelChair,
        onChanged: (bool value) {
          setState(() {
            hasWheelChair = value;
          });
        },
      ),
      CheckboxListTile(
        title: Text(AppLocalizations.of(context).translate('creditCard')),
        value: hasCreditCard,
        onChanged: (bool value) {
          setState(() {
            hasCreditCard = value;
          });
        },
      ),
      CheckboxListTile(
        title: Text(AppLocalizations.of(context).translate('24Hours')),
        value: hasAllTimeService,
        onChanged: (bool value) {
          setState(() {
            hasAllTimeService = value;
          });
        },
      ),
    ];
    return checkboxes;
  }

  List<TextField> getTextFields(int start, int end, BuildContext context) {
    List<TextField> textFields = [];
    for (var i = start; i < end; i++) {
      textFields.add(_buildTextField(listingFields[i], context));
    }
    return textFields;
  }

  @override
  void initState() {
    super.initState();
    listingFields = getListingsFields();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.businessId != null && !isLoadedOnce) {
      setOldData(context);
      setState(() {
        isLoadedOnce = true;
      });
    }
    List<Step> steps = _buildSteps(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate('addListing'),
          style: Theme.of(context).textTheme.title,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stepper(
              onStepTapped: (int index) {
                setState(() {
                  currentStep = index;
                });
              },
              onStepCancel: () {
                Navigator.pop(context);
              },
              type: StepperType.vertical,
              steps: steps,
              currentStep: currentStep,
              onStepContinue: () {
                if (currentStep == steps.length - 1) {
                  onSubmit(context);
                } else {
                  setState(() {
                    currentStep = currentStep + 1;
                  });
                }
              },
            ),
    );
  }

  void setOldData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final AccountService accountService =
          Provider.of<AccountService>(context);
      final BusinessItem business = await ExplorePageService.getBusinessItem(
          widget.businessId, accountService.currentUser.userId);
      if (business == null) {
        throw Exception('returned null');
      }

      nameCtrl.text = business.name;
      nameArCtrl.text = business.nameAr;
      descriptionCtrl.text = business.description;
      descriptionArCtrl.text = business.descriptionAr;
      addressCtrl.text = business.address;
      addressArCtrl.text = business.addressAr;
      latCtrl.text = business.lat.toString();
      lngCtrl.text = business.lng.toString();
      phoneCtrl.text = business.phone;
      taglineCtrl.text = business.tagline;
      taglineArCtrl.text = business.taglineAr;
      websiteCtrl.text = business.websiteUrl;
      emailCtrl.text = business.email;
      hasCarParking = business.facilities.carparking;
      hasWifi = business.facilities.wifi;
      hasPrayerRoom = business.facilities.prayerroom;
      hasWheelChair = business.facilities.wheelchair;
      hasCreditCard = business.facilities.creditcard;
      hasAllTimeService = business.facilities.is24hours;
      mondayCtrl.text = business.timing.monday;
      tuesdayCtrl.text = business.timing.tuesday;
      wednesdayCtrl.text = business.timing.wednesday;
      thursdayCtrl.text = business.timing.thursday;
      fridayCtrl.text = business.timing.friday;
      saturdayCtrl.text = business.timing.saturday;
      sundayCtrl.text = business.timing.sunday;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void onSubmit(BuildContext context) async {
    bool isEdit = false;
    if (widget.businessId != null) {
      isEdit = true;
    }
    setState(() {
      isLoading = true;
    });
    final AccountService accountService = Provider.of<AccountService>(context);
    try {
      Map<String, dynamic> data = {
        'CompanyName': nameCtrl.text,
        'CompanyNameArb': nameArCtrl.text,
        'CompanyDescription': descriptionCtrl.text,
        'CompanyDescriptionArb': descriptionArCtrl.text,
        'CompanyCategory': categoryCtrl.text,
        'CompanyLocation': addressCtrl.text,
        'CompanyLocationArb': addressArCtrl.text,
        'lat': latCtrl.text,
        'lng': lngCtrl.text,
        'companyphone': phoneCtrl.text,
        'company_tagline': taglineCtrl.text,
        'company_taglineArb': taglineArCtrl.text,
        'company_website': websiteCtrl.text,
        'company_email': emailCtrl.text,
        'area': areaCtrl.text,
        'location': locationCtrl.text,
        'CarParking': hasCarParking ? 1 : 0,
        'Wifi': hasWifi ? 1 : 0,
        'PrayerRoom': hasPrayerRoom ? 1 : 0,
        'Wheelchair': hasWheelChair ? 1 : 0,
        'CreditCard': hasCreditCard ? 1 : 0,
        'AlltimeService': hasAllTimeService ? 1 : 0,
        'facebook': facebookCtrl.text,
        'instagram': instagramCtrl.text,
        'linked': linkedinCtrl.text,
        'twitter': twitterCtrl.text,
        'youtube': youtubeCtrl.text,
        'monday': mondayCtrl.text,
        'tuesday': tuesdayCtrl.text,
        'wednesday': wednesdayCtrl.text,
        'thursday': thursdayCtrl.text,
        'friday': fridayCtrl.text,
        'saturday': saturdayCtrl.text,
        'sunday': sundayCtrl.text,
      };
      bool result;
      if (isEdit) {
        data['CompanyId'] = widget.businessId;
        result = await ExplorePageService.editBusiness(
          accountService.currentUser.userId,
          data,
        );
      } else {
        result = await ExplorePageService.addBusiness(
            accountService.currentUser.userId,
            data,
            backgroundImage,
            profileImage);
      }
      setState(() {
        isLoading = false;
      });
      if (result) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  TextField _buildTextField(ListingField listingField, BuildContext context) {
    return TextField(
      controller: listingField.controller,
      focusNode: listingField.focusNode,
      decoration: InputDecoration(
        labelText: listingField.hintText,
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
        hasFloatingPlaceholder: true,
        hintText: listingField.hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Theme.of(context).accentColor),
        // ),
      ),
      cursorColor: Theme.of(context).accentColor,
    );
  }
}

class ListingField {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;

  ListingField({this.controller, this.focusNode, this.hintText});
}
