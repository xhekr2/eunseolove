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
                // SizedBox(
                //   height: 35,
                //   child: ListView.separated(
                //     scrollDirection: .horizontal,
                //     itemBuilder: itemBuilder,
                //     separatorBuilder: separatorBuilder,
                //     itemCount: itemCount,
                //   ),
                // ),
              ],
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
          GestureDetector(onTap: () {}, child: icon('ic_barcode')),
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
