import 'package:easy_shopping/model/firebase.dart';

class OptionConditions {
  /////////////////    USER OPTIONS    /////////////////

  static bool familyAndFriends() {
    return currentRoll == USER;
  }

  static bool stores() {
    return currentRoll == USER;
  }

  static bool services() {
    return currentRoll == USER;
  }

  static bool shoppingCart() {
    return currentRoll == USER;
  }

  static bool pendingOrder() {
    return currentRoll == USER;
  }

  static bool orderHistory() {
    return currentRoll == USER;
  }

  static bool reservationsHistory() {
    return currentRoll == USER;
  }

  /////////////////    DELIVERY MAN  OPTIONS    /////////////////

  static bool ordersToDeliver() {
    return currentRoll == DELIVERY_MAN;
  }

  static bool activeOrders() {
    return currentRoll == DELIVERY_MAN;
  }

  static bool deliveryHistory() {
    return currentRoll == DELIVERY_MAN;
  }

  /////////////////    STORE MANAGER OPTIONS    /////////////////

  static bool addProducts() {
    return currentRoll == STORE_MANAGER;
  }

  static bool storeProducts() {
    return currentRoll == STORE_MANAGER;
  }

  static bool storeSales() {
    return currentRoll == STORE_MANAGER;
  }

  static bool bestSellingProducts() {
    return currentRoll == STORE_MANAGER;
  }

  static bool income() {
    return currentRoll == STORE_MANAGER;
  }

  static bool publicity() {
    return currentRoll == STORE_MANAGER;
  }

  static bool storeInformation() {
    return currentRoll == STORE_MANAGER;
  }

  static bool settings() {
    return currentRoll == STORE_MANAGER;
  }

  /////////////////    PROJECT MANGER     /////////////////

  static bool managePublicity() {
    return currentRoll == PROJECT_MANAGER;
  }

  static bool emitNews() {
    return currentRoll == PROJECT_MANAGER;
  }

  static bool settingsProjectManager() {
    return currentRoll == PROJECT_MANAGER;
  }

  static bool informationProjectManager() {
    return currentRoll == PROJECT_MANAGER;
  }

  /////////////////    GENERAL OPTIONS    /////////////////

  static bool userInformation() {
    return currentRoll == USER || currentRoll == DELIVERY_MAN;
  }

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
