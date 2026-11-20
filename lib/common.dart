import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/store.dart';

Widget icon(String asset, {double? w, double? h, Color? c}) {
  return Image.asset(
    'assets/icons/$asset.png',
    width: w,
    height: h ?? 24,
    color: c,
  );
}

Widget image(String asset, {double? w, double? h, Color? c}) {
  return Image.asset(
    'assets/images/$asset.png',
    width: w,
    height: h ?? 24,
    color: c,
  );
}

Widget imageNet(String url, {double? w, double? h, Color? c, BoxFit? f}) {
  return Image.network(url, width: w, height: h ?? 24, color: c, fit: f);
}

Widget updateWidget(Widget Function() builder) {
  return ValueListenableBuilder(
    valueListenable: updateCount,
    builder: (context, value, child) => builder(),
  );
}

Widget title(String text, {double? s}) {
  return Row(
    children: [
      Text(
        text,
        style: TextStyle(
          color: const Color(0xFF333D4E),
          fontSize: s ?? 12,
          fontWeight: .w700,
        ),
      ),
    ],
  );
}

Widget textField(
  TextEditingController controller,
  String hintText, {
  bool? obscure,
  bool? error,
  String? errText,
  void Function(String)? ch,
  void Function()? cp,
  Widget? p,
  Widget? s,
  double? r,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure ?? false,
    onChanged: ch,
    onEditingComplete: cp,
    decoration: InputDecoration(
      prefixIcon: p != null
          ? Padding(padding: const EdgeInsets.all(12), child: p)
          : null,
      suffixIcon: s != null
          ? Padding(padding: const EdgeInsets.all(12), child: s)
          : null,
      filled: true,
      fillColor: (error ?? false) ? errorColor1 : fieldColor,
      errorText: errText,
      errorStyle: TextStyle(color: errorColor2),
      hintText: hintText,
      hintStyle: const TextStyle(color: eleColor),
      border: OutlineInputBorder(
        borderRadius: .circular(r ?? 12),
        borderSide: .none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: .circular(r ?? 12),
        borderSide: .new(width: 1.5, color: errorColor2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: .circular(r ?? 12),
        borderSide: .new(width: 1.5, color: errorColor2),
      ),
    ),
  );
}
