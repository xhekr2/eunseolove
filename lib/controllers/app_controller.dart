import 'dart:async';
import 'dart:convert';

import 'package:pocket_market_module_a/models/product_model.dart';
import 'package:pocket_market_module_a/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AppController appController = AppController();

class AppController {
  Timer? _timer;
  late SharedPreferences prefs;
  bool validToken = false;
  Set<String> selectCategories = {};
  int currentIndex = 0;
  int unreadCount = 0;
  List<ProductModel> products = [];
  List<ProductModel> favorites = [];
  bool favLoading = false;
  Set<int> favRequesting = {};

  Future<void> toggleFav(ProductModel model) async {
    try {
      if (favRequesting.contains(model.id)) return;
      final next = !model.isFavorite;
      final res = model.isFavorite
          ? await d('/favorites/${model.id}')
          : await po('/favorites/${model.id}', {});
      if (res.statusCode == 200) {
        for (final p in [...products, ...favorites]) {
          if (p.id == model.id) p.isFavorite = next;
        }
      }
    } catch (e) {} finally {
      favRequesting.remove(model.id);
    }
  }
}

Future<void> getNotification() async {
  try {
    final res = await g('/notifications');
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      unreadCount = body['unreadCount'];
      updateScreen();
    }
  } catch (e) {}
}

Future<void> getFavorites() async {
  try {
    final res = await g('/favorites');
    final body = jsonDecode(res.body);
    appController.favorites = (body['items'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  } catch (e) {}
}

void polling() async {
  if (_timer != null) return;
  _timer = Timer.periodic(
    const Duration(seconds: 30),
        (_) async => await getNotification(),
  );
}

Future<void> init() async {
  prefs = await SharedPreferences.getInstance();
  token = prefs.getString(tokenKey);

  if (token != null) {
    try {
      final res = await g('/users/me');
      if (res.statusCode == 200) {
        validToken = true;
        polling();
      }
    } catch (e) {}
  }
}}
