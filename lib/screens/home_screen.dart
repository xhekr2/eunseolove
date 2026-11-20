import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/models/detail_model.dart';
import 'package:pocket_market_module_a/models/product_model.dart';
import 'package:pocket_market_module_a/screens/detail_screen.dart';
import 'package:pocket_market_module_a/store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final search = TextEditingController();
  final barcode = TextEditingController();
  final menu = MenuController();
  final scroll = ScrollController();
  final categories = ["전체", "디지털기기", "도서", "의류", "가구", "스포츠", "음반", "게임", "기타"];
  final sort = [
    {'name': '최신 등록순', 'value': 'latest'},
    {'name': '인기순', 'value': 'popular'},
    {'name': '낮은 가격순', 'value': 'price_asc'},
    {'name': '높은 가격순', 'value': 'price_desc'},
  ];
  int selectSort = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
    query();
    page++;
    appController.getNotification();
    scroll.addListener(() async {
      if (scroll.offset >= scroll.position.maxScrollExtent) {
        await getProductMore();
      }
    });
  }

  Future<Response> getProduct({int? p}) async {
    return await g('/products', {
      "page": p ?? 1,
      "search": search.text,
      "category": appController.selectCategories.join(","),
      "sort": sort[selectSort]['value'],
    });
  }

  Future<void> getProductMore() async {
    try {
      final res = await getProduct(p: page);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        page++;
        final temp = (body['items'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        appController.products.addAll(temp);
        if (!mounted) return;
        updateScreen();
      }
    } catch (e) {}
  }

  Future<void> query() async {
    try {
      final res = await getProduct(p: 1);
      page = 2;
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        appController.products = (body['items'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        if (!mounted) return;
        updateScreen();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => RefreshIndicator(
        backgroundColor: bgColor,
        color: mainColor,
        onRefresh: () async => await query(),
        child: Scaffold(
          appBar: _appBar(),
          body: Padding(
            padding: const .symmetric(horizontal: 12),
            child: Column(
              children: [
                textField(
                  search,
                  '상품명을 검색하세요',
                  r: 30,
                  p: icon('ic_search', c: eleColor),
                  cp: () async => await query(),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: .horizontal,
                    itemBuilder: (context, index) =>
                        categoryChip(index, categories[index]),
                    separatorBuilder: (_, _) => SizedBox(width: 8),
                    itemCount: categories.length,
                  ),
                ),
                const SizedBox(height: 10),
                sortSec(),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 220,
                    ),
                    controller: scroll,
                    itemCount: appController.products.length,
                    itemBuilder: (context, index) {
                      final model = appController.products[index];
                      return GestureDetector(
                        onTap: () async {
                          final res = await g('/products/${model.id}');
                          push(
                            DetailScreen(
                              model: DetailModel.fromJson(jsonDecode(res.body)),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: 5,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      clipBehavior: .hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: .circular(12),
                                      ),
                                      child: imageNet(
                                        model.imageUrl,
                                        f: .cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    bottom: 8,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await appController.toggleFav(model);
                                        if (!mounted) return;
                                        updateScreen();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          shape: .circle,
                                        ),
                                        width: 30,
                                        height: 30,
                                        child: Center(
                                          child: icon(
                                            model.isFavorite
                                                ? 'ic_heart_filled'
                                                : 'ic_heart',
                                            h: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              model.name,
                              style: const TextStyle(fontWeight: .bold),
                            ),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  '${format(model.price)}원',
                                  style: const TextStyle(
                                    fontWeight: .bold,
                                    color: mainColor,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF0E9),
                                    borderRadius: .circular(6),
                                  ),
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      model.condition,
                                      style: TextStyle(
                                        color: mainColor,
                                        fontWeight: .bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sortSec() {
    return Row(
      children: [
        Text(
          '총 ',
          style: TextStyle(color: Colors.grey.shade700, fontWeight: .bold),
        ),
        Text(
          '${appController.products.length}',
          style: const TextStyle(fontWeight: .bold),
        ),
        Text(
          '개',
          style: TextStyle(color: Colors.grey.shade700, fontWeight: .bold),
        ),
        const Spacer(),
        MenuAnchor(
          style: MenuStyle(backgroundColor: .all(bgColor)),
          controller: menu,
          menuChildren: .generate(
            sort.length,
            (index) => MenuItemButton(
              style: ButtonStyle(minimumSize: .all(Size(120, 40))),
              onPressed: () async {
                selectSort = index;
                await query();
                setState(() {});
              },
              child: Text(sort[index]['name']!),
            ),
          ),
          child: GestureDetector(
            onTap: () => menu.open(),
            child: Row(
              children: [
                Text(
                  sort[selectSort]['name']!,
                  style: const TextStyle(fontWeight: .bold),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryChip(int index, String value) {
    final isSelected = appController.selectCategories.contains(value);
    final isAll = index == 0;
    final allSelect = appController.selectCategories.isEmpty && isAll;
    return GestureDetector(
      onTap: () async {
        if (isAll) {
          appController.selectCategories.clear();
        } else {
          appController.selectCategories.add(value);
        }
        await query();
        setState(() {});
      },
      child: Container(
        padding: const .symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected || allSelect
              ? mainColor
              : isAll
              ? Colors.grey.shade400
              : fieldColor,
          borderRadius: .circular(20),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              color: isSelected || allSelect
                  ? Colors.white
                  : Colors.grey.shade700,
              fontWeight: .bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Row(
        spacing: 10,
        children: [
          Image.asset('assets/app_icon.png', height: 35),
          const Text('Pocket Market', style: TextStyle(fontWeight: .bold)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  String? barcodeError;
                  return StatefulBuilder(
                    builder: (context, dialogSet) => AlertDialog(
                      constraints: .tightFor(height: 237, width: .maxFinite),
                      backgroundColor: bgColor,
                      content: Column(
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .center,
                        children: [
                          const Text(
                            '바코드 검색',
                            style: TextStyle(fontWeight: .bold, fontSize: 16),
                          ),
                          Text(
                            '상품 바코드를 입력하세요.',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            keyboardType: .number,
                            controller: barcode,
                            decoration: InputDecoration(
                              hintText: '바코드 번호 (8~13자리)',
                              hintStyle: TextStyle(
                                color: eleColor,
                                fontSize: 12,
                                fontWeight: .bold,
                              ),
                              errorText: barcodeError,
                              errorStyle: TextStyle(
                                color: errorColor2,
                                fontSize: 12,
                              ),
                              prefixIcon: Padding(
                                padding: const .all(12),
                                child: icon('ic_barcode', c: mainColor),
                              ),
                              suffixIcon: Padding(
                                padding: const .all(10),
                                child: Container(
                                  padding: const .symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: fieldColor,
                                    borderRadius: .circular(4),
                                  ),
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      '123',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: .bold,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: .circular(12),
                                borderSide: .new(color: mainColor, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: .circular(12),
                                borderSide: .new(
                                  color: errorColor2,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: .circular(12),
                                borderSide: .new(
                                  color: errorColor2,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: .circular(12),
                                borderSide: .new(
                                  color: errorColor2,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: .circular(12),
                                borderSide: .new(
                                  color: errorColor2,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () => pop(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: fieldColor,
                                    borderRadius: .circular(12),
                                  ),
                                  height: 45,
                                  width: 90,
                                  child: const Center(
                                    child: Text(
                                      '취소',
                                      style: TextStyle(fontWeight: .bold),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  barcodeError = null;
                                  dialogSet(() {});
                                  if (!(barcode.text.length >= 8 &&
                                      barcode.text.length <= 13)) {
                                    barcodeError = '8~13자리 숫자를 입력해주세요';
                                    dialogSet(() {});
                                    return;
                                  }
                                  await barcodeScan(barcode.text);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: .circular(12),
                                  ),
                                  height: 45,
                                  width: 90,
                                  child: const Center(
                                    child: Text(
                                      '검색',
                                      style: TextStyle(
                                        fontWeight: .bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: icon('ic_barcode'),
          ),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: 32,
              width: 32,
              child: Stack(
                children: [
                  Center(child: icon('ic_bell')),
                  if (appController.unreadCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: Colors.red.shade400,
                          border: .all(color: Colors.white),
                        ),
                        width: 17,
                        height: 17,
                        child: Center(
                          child: Text(
                            appController.unreadCount > 9
                                ? '9+'
                                : '${appController.unreadCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: .bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> barcodeScan(String code) async {
    final res = await g('/products/barcode/$code');
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final res2 = await g('/products/${body['id']}');
      final body2 = jsonDecode(res2.body);
      pop();
      push(DetailScreen(model: DetailModel.fromJson(body2)));
    } else {
      showToast(body['message']);
      return;
    }
  }
}
