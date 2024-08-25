import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../repo/accountRepo.dart';

class AccountController extends GetxController implements GetxService {
  final AccountRepo accountRepo;

  AccountController({
    required this.accountRepo,
  });

  final paFirstNameController = TextEditingController();
  final paLastNameController = TextEditingController();
  final paEmailController = TextEditingController();
  final paPhoneController = TextEditingController();
  final paCountryController = TextEditingController();
  final paCityController = TextEditingController();
  final paAreaController = TextEditingController();
  final paBuildController = TextEditingController();
  final paVillaNumController = TextEditingController();
  final paZipCodeController = TextEditingController();

  Map<String, dynamic> get addressPreference => _addressPreference;
  final Map<String, dynamic> _addressPreference = {};

  List addressPreferenceList = [];
  bool isPAButton = true;

  onchangeValue(String key, String value) {
    _addressPreference[key] = value;
    isPAButton = !(paFirstNameController.text.isNotEmpty &&
        paLastNameController.text.isNotEmpty &&
        paEmailController.text.isNotEmpty &&
        paPhoneController.text.isNotEmpty &&
        paCountryController.text.isNotEmpty &&
        paCityController.text.isNotEmpty &&
        paAreaController.text.isNotEmpty &&
        paBuildController.text.isNotEmpty &&
        paVillaNumController.text.isNotEmpty &&
        paZipCodeController.text.isNotEmpty);
  }

  List<Map<String, dynamic>> list = [];
  padButtonEnable() {
    addressPreferenceList.add(addressPreference);
    update();
  }

  addressTextClean() {
    paFirstNameController.clear();
    paLastNameController.clear();
    paEmailController.clear();
    paPhoneController.clear();
    paCountryController.clear();
    paCityController.clear();
    paAreaController.clear();
    paBuildController.clear();
    paVillaNumController.clear();
    paZipCodeController.clear();
    isPAButton = true;
    update();
  }

  bool isConcerned = false;
  concernedCheck() {
    isConcerned = !isConcerned;
    update();
  }

  bool isFront = false;
  frontCheck() {
    isFront = !isFront;
    update();
  }
}
