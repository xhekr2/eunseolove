import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/models/product_model.dart';
import 'package:pocket_market_module_a/store.dart';

class DetailScreen extends StatelessWidget {
  final ProductModel model;

  const DetailScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                imageNet(model.imageUrl, h: 350, w: .maxFinite, f: .cover),
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topCenter,
                      end: .bottomCenter,
                      colors: [Colors.black.withAlpha(110), Colors.transparent],
                    ),
                  ),
                  child: Padding(
                    padding: const .symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => pop(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              shape: .circle,
                            ),
                            height: 40,
                            width: 40,
                            child: Center(child: icon('ic_back')),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await appController.toggleFav(model);
                            updateScreen();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              shape: .circle,
                            ),
                            height: 40,
                            width: 40,
                            child: Center(
                              child: model.isFavorite
                                  ? icon('ic_heart_filled')
                                  : icon('ic_heart'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
