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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12),
          child: GestureDetector(onTap: () => pop(), child: icon('ic_back')),
        ),
        title: Text('회원가입', style: TextStyle(fontWeight: .bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            title('이메일', s: 14),
            const SizedBox(height: 10),
            textField(email, 'example@email.com'),
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
            ),
            const SizedBox(height: 12),
            title('비밀번호 확인', s: 14),
            const SizedBox(height: 10),
            textField(
              passwordCheck,
              '비밀번호를 한 번 더 입력하세요',
              obscure: obscurePwCheck,
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
            textField(name, '이름을 입력하세요'),
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
              ],
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
            const SizedBox(height: 120),
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
          ],
        ),
      ),
    );
  }
}

// enum EmailErrorType {
//   empty('이메일은 필수 값입니다.'),
//   notCoA('이메일에 @를 필수로 작성해주세요.'),
//   notCoDot('이메일에 .을 필수로 작성해주세요.'),
//   beforeCoDot('이메일에서 @앞에 .은 사용 불가능 합니다.');
//
//   final String msg;
//
//   const new(this.msg);
// }
//
// enum PasswordErrorType {
//   empty('비밀번호는 필수 값입니다.'),
//   noEnoLen('비밀번호를 8자 이상으로 작성해주세요.'),
//   noUpper('비밀번호를 대문자 1자 이상으로 작성해주세요.'),
//   noLower('비밀번호를 소문자 1자 이상으로 작성해주세요.');
//
//   final String msg;
//
//   const new(this.msg);
// }
