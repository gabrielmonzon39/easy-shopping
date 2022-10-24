import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/colors.dart';
import 'package:easy_shopping/model/firebase.dart';

Future<void> getAndSetNameImage() async {
  String projectId = await getProjectId();
  try {
    projectName = await FirebaseFS.getProjectName(projectId);
  } catch (e) {
    projectName = defaultProjectName;
  }
  try {
    projectImage = await FirebaseFS.getProjectImage(projectId);
  } catch (e) {
    projectImage = defaultProjectImage;
  }
}
