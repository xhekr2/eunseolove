import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/screens/base_screen.dart';
import 'package:pocket_market_module_a/screens/sign_up_screen.dart';
import 'package:pocket_market_module_a/store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool obsPW = true;

  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
  }

  void login() async {
    emailError = null;
    passwordError = null;
    setState(() {});

    if (email.text.isEmpty) {
      emailError = '이메일은 필수 입력 값입니다';
    }

    if (password.text.isEmpty) {
      passwordError = '비밀번호는 8자 이상 입력해 주세요.';
    }

    setState(() {});

    if (emailError != null || passwordError != null) return;

    try {
      final res = await po('/auth/login', {
        "email": email.text,
        "password": password.text,
      });

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        token = body['accessToken'];
        await appController.prefs.setString(tokenKey, token!);
        appController.polling();
        rePush(BaseScreen());
      } else {
        showToast(body['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            image('logo_color', h: 80),
            const Text(
              'Pocket Market',
              style: TextStyle(fontSize: 24, fontWeight: .w700),
            ),
            const SizedBox(height: 40),
            title('이메일'),
            const SizedBox(height: 10),
            textField(
              email,
              'example@email.com',
              errText: emailError,
              error: emailError != null,
              p: icon(
                'ic_mail',
                c: emailError != null ? errorColor2 : eleColor,
              ),
            ),
            const SizedBox(height: 12),
            title('비밀번호'),
            const SizedBox(height: 10),
            textField(
              password,
              '비밀번호를 입력하세요',
              s: GestureDetector(
                onTap: () => setState(() => obsPW = !obsPW),
                child: icon(obsPW ? 'ic_eye_off' : 'ic_eye', c: eleColor),
              ),
              error: passwordError != null,
              p: icon(
                'ic_lock',
                c: passwordError != null ? errorColor2 : eleColor,
              ),
              errText: passwordError,
              obscure: obsPW,
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: login,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: .circular(12),
                ),
                height: 55,
                child: const Center(
                  child: Text(
                    '로그인',
                    style: TextStyle(color: Colors.white, fontWeight: .bold),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: .center,
              children: [
                Text(
                  '계정이 없으신가요?',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                TextButton(
                  onPressed: () => push(SignUpScreen()),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 12,
                      fontWeight: .bold,
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
