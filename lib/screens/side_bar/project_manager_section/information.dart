// ignore_for_file: empty_catches, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/information_project_view.dart';
import 'package:easy_shopping/widgets/information_store_service_view.dart';
import 'package:flutter/material.dart';

class ProjectInformationSection extends StatefulWidget {
  const ProjectInformationSection({Key? key}) : super(key: key);
  @override
  ProjectInformationSectionBuilder createState() =>
      ProjectInformationSectionBuilder();
}

class ProjectInformationSectionBuilder
    extends State<ProjectInformationSection> {
  String? name;
  String? imageURL;
  bool availableRefresh = true;

  Future<bool> calculateProjectId() async {
    String projectId = await FirebaseFS.getProjectIdForProjectManager(uid!);

    DocumentSnapshot? projectDetails =
        await FirebaseFS.getProjectDetails(projectId);
    if (projectDetails == null) return false;

    try {
      name = projectDetails.get('name');
    } catch (e) {
      name = defaultProjectName;
    }

    try {
      imageURL = projectDetails.get('image');
    } catch (e) {
      imageURL = defaultProjectImage;
    }

    availableRefresh = false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (availableRefresh) calculateProjectId();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Información"),
        ),
        body: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ////////////////////////////////////////////////////////////////
                    FutureBuilder<bool>(
                        future: calculateProjectId(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (!snapshot.hasData) {
                            // not loaded
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            // some error
                            return Column(children: const [
                              Text(
                                "Lo sentimos, ha ocurrido un error",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              Icon(
                                Icons.close,
                                size: 100,
                              ),
                            ]);
                          } else {
                            // loaded
                            bool? valid = snapshot.data;
                            if (valid!) {
                              return InformationProjectView(
                                  name: name, imageURL: imageURL);
                            }
                          }
                          return Center(
                              child: Column(children: const [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "¡Ups! Ha ocurrido un error al obtener los datos.",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Icon(
                              Icons.sentiment_very_dissatisfied,
                              size: 100,
                            ),
                          ]));
                        }),
                    ////////////////////////////////////////////////////////////////
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
