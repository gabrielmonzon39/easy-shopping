import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/colors.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:easy_shopping/widgets/news_view.dart';
import 'package:flutter/material.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({Key? key}) : super(key: key);
  @override
  NewsSectionBuilder createState() => NewsSectionBuilder();
}

class NewsSectionBuilder extends State<NewsSection> {
  List<Widget> list = [];
  Widget? result;

  Future<bool> getNews() async {
    QuerySnapshot snapNews = await FirebaseFirestore.instance
        .collection('news')
        .orderBy('date', descending: true)
        .get();
    String projectId = await getProjectId();
    for (var document in snapNews.docs) {
      if (projectId != document.get('project_id')) continue;
      Timestamp dateTS = document.get('date');
      DateTime date = dateTS.toDate();
      String title = document.get('title');
      String body = document.get('body');
      String image = document.get('image');
      list.add(Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsView(
                        title: title,
                        body: body,
                        date: date.toString(),
                        image: image,
                      )),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return ternaryColor;
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    date.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              const Icon(Icons.notifications, size: 35),
            ],
          ),
        ),
      ));
      list.add(const SizedBox(height: 5));
    }
    result = Column(
      children: list,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    list = [];
    result = null;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text("Noticias"),
        ),
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            height: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ////////////////////////////////////////////////////////////////
                Expanded(
                    child: SingleChildScrollView(
                  child: FutureBuilder<bool>(
                      future: getNews(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                            return result!;
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
                )),
                /////////////////////////////////////////////
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
