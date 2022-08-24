import 'package:easy_shopping/model/firebase.dart';

class OptionConditions {
  /////////////////    USER OPTIONS    /////////////////

  static bool familyAndFriends() {
    return currentRoll == USER;
  }

  static bool storesAndServices() {
    return currentRoll == USER;
  }

  static bool orderHistory() {
    return currentRoll == USER;
  }

  static bool reservationsHistory() {
    return currentRoll == USER;
  }

  /////////////////    STORE MANAGER OPTIONS    /////////////////

  static bool storeProducts() {
    return currentRoll == STORE_MANAGER;
  }

  static bool storeSales() {
    return currentRoll == STORE_MANAGER;
  }

  static bool storeInformation() {
    return currentRoll == STORE_MANAGER;
  }

  /////////////////    GENERAL OPTIONS    /////////////////

  static bool notifications() {
    return currentRoll != NONE;
  }

  static bool token() {
    return true;
  }

  static bool logOut() {
    return true;
  }
}
