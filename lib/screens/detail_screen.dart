import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/models/detail_model.dart';
import 'package:pocket_market_module_a/store.dart';

class DetailScreen extends StatelessWidget {
  final DetailModel model;

  const DetailScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => Scaffold(
        body: Column(
          spacing: 10,
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
                            final same = appController.products.where((
                              element,
                            ) {
                              return element.id == model.id;
                            }).first;
                            model.isFavorite = same.isFavorite;
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
            Expanded(
              child: Padding(
                padding: const .symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      model.name,
                      style: TextStyle(fontWeight: .bold, fontSize: 20),
                    ),
                    Text(
                      '${format(model.price)}원',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 20,
                        fontWeight: .bold,
                      ),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: const .symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius: .circular(22),
                          ),
                          child: Text(
                            model.category,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: .bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const .symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius: .circular(22),
                          ),
                          child: Text(
                            '${model.condition}등급',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: .bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const .symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: fieldColor,
                            borderRadius: .circular(22),
                          ),
                          child: Text(
                            model.tradeType,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: .bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFFEF0E9),
                          child: Text(
                            model.seller['name'][0],
                            style: TextStyle(
                              fontWeight: .bold,
                              color: mainColor,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              model.seller['name'],
                              style: TextStyle(fontWeight: .bold),
                            ),
                            Text(
                              model.seller['email'],
                              style: TextStyle(
                                fontWeight: .bold,
                                color: eleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Text('상태 설명', style: TextStyle(fontWeight: .bold)),
                    Row(
                      spacing: 6,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: .circular(4),
                          ),
                          height: 22,
                          width: 22,
                          child: Center(
                            child: Text(
                              model.condition,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          model.conditionLabel,
                          style: TextStyle(fontWeight: .bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('상태 설명', style: TextStyle(fontWeight: .bold)),
                    Text(
                      model.description,
                      style: TextStyle(color: eleColor, fontWeight: .bold),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: .fromLTRB(
                  top: .new(color: Colors.grey.shade300, width: 1.5),
                ),
              ),
              padding: const .symmetric(horizontal: 12, vertical: 8),
              width: .maxFinite,
              height: 80,
              child: GestureDetector(
                onTap: () {
                  showToast('준비중입니다');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: .circular(12),
                  ),
                  child: Row(
                    spacing: 5,
                    mainAxisAlignment: .center,
                    children: [
                      icon('ic_chat', c: Colors.white),
                      Text(
                        '채팅하기',
                        style: TextStyle(
                          fontWeight: .bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
