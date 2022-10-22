// ignore_for_file: empty_catches

import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:flutter/cupertino.dart';

Future<void> getAndSetColors() async {
  String projectId = await getProjectId();
  try {
    primaryColor = Color(await FirebaseFS.getPrimaryColor(projectId));
    secondaryColor = Color(await FirebaseFS.getSecondaryColor(projectId));
    ternaryColor = Color(await FirebaseFS.getTernaryColor(projectId));
  } catch (e) {
    primaryColor = defaultPrimaryColor;
    secondaryColor = defaultSecondaryColor;
    ternaryColor = defaultTernaryColor;
  }
}

Future<String> getProjectId() async {
  try {
    switch (currentRoll) {
      case NONE:
        return NONE;
      case USER:
        return await FirebaseFS.getProjectId(uid!);
      case DELIVERY_MAN:
        return FirebaseFS.getProjectIdForDeliveryMan(uid!);
      case STORE_MANAGER:
        return FirebaseFS.getProjectIdForStoreManager(uid!);
      case PROJECT_MANAGER:
        return await FirebaseFS.getProjectIdForProjectManager(uid!);
      case SUPER_ADMIN:
        return NONE;
    }
  } catch (e) {}
  return NONE;
}
