import 'package:easy_shopping/auth/google_sign_in_provider.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/screens/main_screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_shopping/widgets/app_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:easy_shopping/model/category_items.dart';
import 'package:easy_shopping/widgets/category_item_dart_widget.dart';
import 'package:easy_shopping/screens/side_bar/project_manager_section/create_stores.dart';
import 'package:easy_shopping/screens/side_bar/project_manager_section/create_store_managers.dart';
import 'package:easy_shopping/screens/side_bar/project_manager_section/create_family.dart';
import 'package:easy_shopping/screens/side_bar/project_manager_section/create_delivery_man.dart';

class ProjectManagerMainScreen extends StatelessWidget {
  int i = 0;
  List<Color> gridColors = const [
    Color(0xff53B175),
    Color(0xff836AF6),
    Color(0xffD73B77),
    Color(0xffB7DFF5),
    Color(0xffF8A44C),
    Color(0xffF7A593),
    Color(0xffD3B0E0),
    Color(0xffFDE598),
  ];

  ProjectManagerMainScreen({Key? key}) : super(key: key);

  Widget getHeader() {
    return Column(
      children: const [
        SizedBox(
          height: 20,
        ),
        Center(
          child: AppText(
            text: "Menú principal",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  List<Widget> getStaggeredGridView(BuildContext context) {
    List<Widget> options = [];
    for (CategoryItem item in projectManagerItemsDemo) {
      options.add(GestureDetector(
        onTap: () {
          onCategoryItemClicked(context, item);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: CategoryItemCardWidget(
            // HERE LOOP
            item: item,
            color: gridColors[(i - 1) % gridColors.length],
          ),
        ),
      ));
      options.add(const SizedBox(
        height: 20,
      ));
    }
    return options;
  }

  String projectId = "";

  void getProjectId() async {
    projectId = await FirebaseFS.getProjectIdForProjectManager(uid);
  }

  void onCategoryItemClicked(BuildContext context, CategoryItem categoryItem2) {
    String categoryItem = categoryItem2.name!;
    switch (categoryItem) {
      case 'Generar Store Manager':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateStoreManagersSection(
                    projectId: projectId,
                  )),
        );
        break;
      case 'Nueva Tienda':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateStoresSection(
                    projectId: projectId,
                  )),
        );
        break;
      case 'Generar Familia':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateFamilySection(
                    projectId: projectId,
                  )),
        );
        break;
      case 'Generar Delivery Man':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateDeliveryManSection(
                    projectId: projectId,
                  )),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    getProjectId();
    return SizedBox(
      height: 680,
      child: Column(
        children: [
          getHeader(),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: getStaggeredGridView(context).length,
              itemBuilder: (context, index) {
                i++;
                return getStaggeredGridView(context)[i - 1];
              })
        ],
      ),
    );
  }
}
