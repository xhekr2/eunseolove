import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/store.dart';

import '../models/detail_model.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await recallFav());
  }

  Future<void> recallFav() async {
    appController.favLoading = true;
    if (!mounted) {
      appController.favLoading = false;
      return;
    }
    updateScreen();
    await appController.getFavorites();
    appController.favLoading = false;
    if (!mounted) return;
    updateScreen();
  }

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => Scaffold(
        appBar: AppBar(
          title: Text('관심상품', style: TextStyle(fontWeight: .bold)),
        ),
        body: Padding(
          padding: const .symmetric(horizontal: 12, vertical: 2),
          child: Column(
            children: [
              if (appController.favLoading)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: mainColor),
                  ),
                )
              else if (appController.favorites.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF0E9),
                            shape: .circle,
                          ),
                          width: 90,
                          height: 90,
                          child: Center(
                            child: icon('ic_heart', c: mainColor, h: 36),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '관심상품이 없습니다.',
                          style: TextStyle(fontWeight: .bold, fontSize: 16),
                        ),
                        const Text(
                          '마음에 드는 상품에 하트를 눌러 보세요.',
                          style: TextStyle(
                            fontWeight: .bold,
                            color: eleColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final model = appController.favorites[index];
                      return GestureDetector(
                        onTap: () async {
                          final res = await g('/products/${model.id}');
                          push(
                            DetailScreen(
                              model: DetailModel.fromJson(jsonDecode(res.body)),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              clipBehavior: .hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: .circular(12),
                              ),
                              width: 85,
                              height: 85,
                              child: imageNet(model.imageUrl),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  model.name,
                                  style: TextStyle(fontWeight: .bold),
                                ),
                                Text(
                                  '${format(model.price)}원',
                                  style: TextStyle(
                                    color: mainColor,
                                    fontWeight: .bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                await d('/favorites/${model.id}');
                                await recallFav();
                              },
                              child: icon('ic_heart_filled'),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, _) =>
                        Divider(color: Colors.grey.shade300, height: 22),
                    itemCount: appController.favorites.length,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
