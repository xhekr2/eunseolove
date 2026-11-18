import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return updateWidget(
      () => Scaffold(
        appBar: AppBar(
          title: Text('관심상품', style: TextStyle(fontWeight: .bold)),
        ),
      ),
    );
  }
}
