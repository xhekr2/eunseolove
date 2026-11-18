import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final search = TextEditingController();
  final categories = ["전체", "디지털기기", "도서", "의류", "가구", "스포츠", "음반", "게임", "기타"];

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => RefreshIndicator(
        backgroundColor: bgColor,
        color: mainColor,
        onRefresh: () async {},
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
              ],
            ),
          ),
        ),
      ),
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
        await appController.query();
        updateScreen();
      },
      child: Container(
        padding: const .symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected || allSelect
              ? mainColor
              : isAll
              ? Colors.grey.shade300
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
}
