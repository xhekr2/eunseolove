import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/screens/favorite_screen.dart';
import 'package:pocket_market_module_a/screens/home_screen.dart';
import 'package:pocket_market_module_a/store.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  List body = [HomeScreen(), FavoriteScreen()];

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => Scaffold(
        body: body[appController.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: appController.currentIndex,
          onTap: (i) => setState(() {
            if (i == 2 || i == 3) {
              showToast('준비중입니다.');
              return;
            }
            appController.currentIndex = i;
          }),
          backgroundColor: bgColor,
          type: .fixed,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.grey.shade700,
          items: [
            BottomNavigationBarItem(
              icon: icon(
                'ic_home',
                c: appController.currentIndex == 0
                    ? mainColor
                    : Colors.grey.shade700,
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: icon(
                'ic_heart',
                c: appController.currentIndex == 1
                    ? mainColor
                    : Colors.grey.shade700,
              ),
              label: '관심',
            ),
            BottomNavigationBarItem(
              icon: icon('ic_bell', c: Colors.grey.shade700),
              label: '알림',
            ),
            BottomNavigationBarItem(
              icon: icon('ic_user', c: Colors.grey.shade700),
              label: '마이',
            ),
          ],
        ),
      ),
    );
  }
}
