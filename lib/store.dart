import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

final ValueNotifier<int> updateCount = ValueNotifier(0);

void updateScreen() => updateCount.value++;

const mainColor = Color(0xFFfe6a34);
const bgColor = Color(0xFFFEFEFE);
const errorColor1 = Color(0xFFFDF1F1);
const errorColor2 = Color(0xFFed3737);
const fieldColor = Color(0xFFF6F6F7);
const eleColor = Color(0xFF969eab);

// Navigator

final navKey = GlobalKey<NavigatorState>();

void push(Widget page) =>
    navKey.currentState?.push(MaterialPageRoute(builder: (context) => page));

void rePush(Widget page) => navKey.currentState?.pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => page),
  (route) => false,
);

void pop() => navKey.currentState?.pop();

// HTTP

final String baseUrl = 'http://10.0.2.2:8000';

String? token;
const tokenKey = 'token_key';

get header => {
  "Content-Type": "application/json",
  if (token != null) "Authorization": "Bearer $token",
};

Future<Response> g(String url, [Map? parma]) async {
  final uri = Uri.parse('$baseUrl$url').replace(
    queryParameters: parma?.map(
      (key, value) => MapEntry(key, value.toString()),
    ),
  );

  final res = await get(uri, headers: header);

  return res;
}

Future<Response> po(String url, body) async {
  final res = await post(
    .parse('$baseUrl$url'),
    headers: header,
    body: jsonEncode(body),
  );

  return res;
}

Future<Response> pu(String url) async {
  final res = await put(.parse('$baseUrl$url'), headers: header);
  return res;
}

Future<Response> d(String url) async {
  final res = await delete(.parse('$baseUrl$url'), headers: header);
  return res;
}
