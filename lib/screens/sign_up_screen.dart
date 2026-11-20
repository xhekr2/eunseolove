import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/store.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordCheck = TextEditingController();
  final name = TextEditingController();
  final num1 = TextEditingController();
  final num2 = TextEditingController();
  final num3 = TextEditingController();

  String? emailErr;
  String? passErr;
  String? checkErr;
  String? nameErr;
  String? numErr;

  final numF2 = FocusNode();
  final numF3 = FocusNode();

  bool isAgree = false;
  bool obscurePw = false;
  bool obscurePwCheck = false;

  void signUp() async {
    if (!isAgree) {
      showToast('이용약관에 동의해 주세요.');
      return;
    }

    emailErr = null;
    passErr = null;
    checkErr = null;
    nameErr = null;
    numErr = null;

    setState(() {});

    if (email.text.isEmpty) {
      emailErr = '이메일은 필수 입력 값입니다.';
    } else if (!email.text.contains('@')) {
      emailErr = '이메일에 "@"기호를 포함해주세요.';
    } else if (!email.text.contains('.')) {
      emailErr = '이메일에 "."기호를 포함해주세요.';
    } else if (email.text.split('@').first.contains('.')) {
      emailErr = '"@" 앞에 "."사용은 불가능 합니다.';
    }

    if (password.text.isEmpty) {
      passErr = '비밀번호는 필수 입력 값입니다.';
    } else if (password.text.length < 8) {
      passErr = '비밀번호를 8자 이상 작성해주세요.';
    } else if (!password.text.contains(RegExp(r'[A-Z]'))) {
      passErr = '비밀번호에 대문자 1자 이상 작성해주세요.';
    } else if (!password.text.contains(RegExp(r'[a-z]'))) {
      passErr = '비밀번호에 소문자 1자 이상 작성해주세요.';
    } else if (!password.text.contains(RegExp(r'[0-9]'))) {
      passErr = '비밀번호에 숫자 1자 이상 작성해주세요.';
    } else if (!password.text.contains(RegExp(r'[^ㄱ-ㅎ가-힣a-zA-Z0-9\s]'))) {
      passErr = '비밀번호에 특수문자 1자 이상 작성해주세요.';
    }

    if (passwordCheck.text.isEmpty) {
      checkErr = '비밀번호 확인은 필수 입력 값입니다.';
    } else if (passwordCheck.text != password.text) {
      checkErr = '비밀번호 확인은 비밀번호와 일치해야 합니다.';
    }

    if (name.text.isEmpty) {
      nameErr = '이름은 필수 입력 값입니다.';
    } else if (name.text.contains(RegExp(r'[^ㄱ-ㅎ가-힣a-zA-Z]'))) {
      nameErr = '이름은 한글 또는 영문만 입력 가능합니다.';
    }

    if (num1.text.isEmpty || num2.text.isEmpty || num3.text.isEmpty) {
      numErr = '휴대폰 번호는 필수 입력 값입니다.';
    } else if (num1.text.contains(RegExp(r'[^0-9]')) ||
        num1.text.contains(RegExp(r'[^0-9]')) ||
        num1.text.contains(RegExp(r'[^0-9]'))) {
      numErr = '휴대폰 번호는 숫자만 입력 가능합니다.';
    }
    setState(() {});

    if (emailErr != null ||
        passErr != null ||
        checkErr != null ||
        nameErr != null ||
        numErr != null) {
      return;
    }

    try {
      final res = await po('/auth/signup', {
        "email": email.text,
        "password": password.text,
        "passwordConfirm": passwordCheck.text,
        "name": name.text,
        "phone": "${num1.text}-${num2.text}-${num3.text}",
      });

      final body = jsonDecode(res.body);

      if (res.statusCode == 201) {
        showToast(body['message']);
        pop();
      } else {
        showToast(body['message']);
        return;
      }
    } catch (e, st) {
      showToast('$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: GestureDetector(onTap: () => pop(), child: icon('ic_back')),
        ),
        title: Text('회원가입', style: TextStyle(fontWeight: .bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            title('이메일', s: 14),
            const SizedBox(height: 10),
            textField(
              email,
              'example@email.com',
              errText: emailErr,
              error: emailErr != null,
            ),
            const SizedBox(height: 12),
            title('비밀번호', s: 14),
            const SizedBox(height: 10),
            textField(
              password,
              '영문•숫자•특수문자 포함 8자 이상',
              obscure: obscurePw,
              s: GestureDetector(
                onTap: () => setState(() => obscurePw = !obscurePw),
                child: icon(obscurePw ? 'ic_eye_off' : 'ic_eye', c: eleColor),
              ),
              errText: passErr,
              error: passErr != null,
            ),
            const SizedBox(height: 12),
            title('비밀번호 확인', s: 14),
            const SizedBox(height: 10),
            textField(
              passwordCheck,
              '비밀번호를 한 번 더 입력하세요',
              obscure: obscurePwCheck,
              error: checkErr != null,
              errText: checkErr,
              s: GestureDetector(
                onTap: () => setState(() => obscurePwCheck = !obscurePwCheck),
                child: icon(
                  obscurePwCheck ? 'ic_eye_off' : 'ic_eye',
                  c: eleColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            title('이름', s: 14),
            const SizedBox(height: 10),
            textField(
              name,
              '이름을 입력하세요',
              errText: nameErr,
              error: nameErr != null,
            ),
            const SizedBox(height: 12),
            title('휴대폰 번호', s: 14),
            const SizedBox(height: 10),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: .number,
                    maxLength: 3,
                    textAlign: .center,
                    controller: num1,
                    onChanged: (v) {
                      if (v.length >= 3) {
                        FocusScope.of(context).requestFocus(numF2);
                      }
                    },
                    decoration: InputDecoration(
                      counter: SizedBox(),
                      filled: true,
                      fillColor: fieldColor,
                      hintStyle: const TextStyle(color: eleColor),
                      hintText: '010',
                      border: OutlineInputBorder(
                        borderSide: .none,
                        borderRadius: .circular(12),
                      ),
                    ),
                  ),
                ),
                Text('-', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: TextField(
                    keyboardType: .number,
                    maxLength: 4,
                    textAlign: .center,
                    focusNode: numF2,
                    controller: num2,
                    onChanged: (v) {
                      if (v.length >= 4) {
                        FocusScope.of(context).requestFocus(numF3);
                      }
                    },
                    decoration: InputDecoration(
                      counter: SizedBox(),
                      filled: true,
                      fillColor: fieldColor,
                      hintText: '0000',
                      hintStyle: const TextStyle(color: eleColor),
                      border: OutlineInputBorder(
                        borderSide: .none,
                        borderRadius: .circular(12),
                      ),
                    ),
                  ),
                ),
                Text('-', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: TextField(
                    keyboardType: .number,
                    maxLength: 4,
                    textAlign: .center,
                    controller: num3,
                    focusNode: numF3,
                    decoration: InputDecoration(
                      counter: const SizedBox(),
                      filled: true,
                      fillColor: fieldColor,
                      hintText: '0000',
                      hintStyle: const TextStyle(color: eleColor),
                      border: OutlineInputBorder(
                        borderSide: .none,
                        borderRadius: .circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (numErr != null)
              Align(
                alignment: .centerRight,
                child: Text(
                  numErr!,
                  style: TextStyle(color: errorColor2, fontSize: 12),
                ),
              ),
            const SizedBox(height: 5),
            Row(
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    activeColor: mainColor,
                    side: .new(color: Colors.grey.shade300, width: 2),
                    value: isAgree,
                    onChanged: (value) => setState(() => isAgree = value!),
                  ),
                ),
                Text('이용약관 동의 ', style: TextStyle(fontWeight: .bold)),
                Text(
                  '(필수)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                const Spacer(),
                Text(
                  '보기',
                  style: TextStyle(
                    decoration: .underline,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: signUp,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: .circular(12),
                ),
                height: 55,
                child: const Center(
                  child: Text(
                    '회원가입',
                    style: TextStyle(color: Colors.white, fontWeight: .bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
