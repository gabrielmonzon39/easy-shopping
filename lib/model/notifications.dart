import 'dart:convert';
import 'dart:math';
import 'package:easy_shopping/constants.dart';
import 'package:easy_shopping/model/firebase.dart';
import 'package:http/http.dart' as http;

void sendNotifications(
    String to, String title, String body, String image) async {
  try {
    int id = Random().nextInt(maxValue);
    http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'to': '/topics/$to',
          'notification': <String, String>{
            'title': title,
            'body': body,
            'image': image
          },
          'data': <String, String>{'msgId': 'msg_$id'},
        },
      ),
    );
    //print("-----------------------------*********************");
    //print(response.body.toString());
    //print("-----------------------------*********************");
  } catch (e) {
    print(e.toString());
  }
}
