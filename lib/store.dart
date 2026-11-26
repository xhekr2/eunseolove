import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:material_ui/material_ui.dart';

const tkn_key = 'tkn_key';

final baseUrl = 'http://10.0.2.2:8000';

final mc = MethodChannel('channel');

final naviKey = GlobalKey<NavigatorState>();

String? tkn;

final updateCount = ValueNotifier<int>(0);

get header => {
  "Content-Type": "applications/json",
  if (tkn != null) "Authorization": "Bearer $tkn",
};

Future<Response> d(String url) async {
  final res = await delete(.parse('$baseUrl/$url'));
  return res;
}

Future<Response> g(String url, [Map? parma]) async {
  final uri = Uri.parse('$baseUrl/$url').replace(
    queryParameters: parma?.map(
      (key, value) => MapEntry(key, value.toString()),
    ),
  );
  final res = await get(uri, headers: header);
  return res;
}

Future<Response> po(String url, body) async {
  final res = await post(
    .parse('$baseUrl/$url'),
    headers: header,
    body: jsonEncode(body),
  );
  return res;
}

void pop() => naviKey.currentState?.pop();

void push(Widget p) =>
    naviKey.currentState?.push(MaterialPageRoute(builder: (context) => p));

void rePush(Widget p) => naviKey.currentState?.pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => p),
  (route) => false,
);

void showToast(String message) => mc.invokeMethod('toast', message);

void updateScreen() => updateCount.value++;
