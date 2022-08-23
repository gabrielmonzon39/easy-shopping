import 'package:easy_shopping/model/firebase.dart';

class OptionConditions {
  static bool familyAndFriends() {
    return currentRoll == USER;
  }

  static bool storesAndServices() {
    return currentRoll == USER;
  }

  static bool notifications() {
    return currentRoll != NONE;
  }

  static bool orderHistory() {
    return currentRoll == USER;
  }

  static bool reservationsHistory() {
    return currentRoll == USER;
  }

  static bool token() {
    return true;
  }

  static bool logOut() {
    return true;
  }
}
