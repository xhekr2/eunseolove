import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/store.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => Scaffold(
        appBar: _appBar(),
        body: Column(children: []),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () => pop(),
        child: Container(
          decoration: BoxDecoration(shape: .circle, color: Colors.white),
        ),
      ),
    );
  }
}
