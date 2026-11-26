import 'package:material_ui/material_ui.dart';

Widget image(String asset, {double? w, double? h, Color? c, BoxFit? f}) {
  return Image.asset(
    'assets/images/$asset.png',
    width: w,
    height: h,
    color: c,
    fit: f,
  );
}

Widget icon(String asset, {double? w, double? h, Color? c, BoxFit? f}) {
  return Image.asset(
    'assets/icons/$asset.png',
    width: w,
    height: h,
    color: c,
    fit: f,
  );
}

Widget imageNet(String url, {double? w, double? h, Color? c, BoxFit? f}) {
  return Image.network(url, width: w, height: h, color: c, fit: f);
}
