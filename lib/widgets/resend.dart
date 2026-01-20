import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResendButton extends StatefulWidget {
  const ResendButton({super.key});

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton> {
  int secondsLeft = 30; // يبدأ العدّ 30 ثانية عند فتح الصفحة
  Timer? _timer;
  bool isBlocked = false; // إذا جاء خطأ من Firebase
  bool initialDelayDone = false; // هل انتهى عدّ الـ30 ثانية الأولي

  @override
  void initState() {
    super.initState();
    startTimer(duration: 30); // عدّ 30 ثانية عند فتح الصفحة
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer({required int duration}) {
    _timer?.cancel();
    setState(() {
      secondsLeft = duration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 0) {
        timer.cancel();

        if (!initialDelayDone) {
          // العدّ الأول انتهى → الزر أصبح متاح
          setState(() {
            initialDelayDone = true;
          });
        }

        if (isBlocked) {
          // انتهاء فترة البلوك الطويل → الزر يصبح متاح
          setState(() {
            isBlocked = false;
          });
        }
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  void onPressed() async {
    if ((secondsLeft > 0 && !initialDelayDone) || isBlocked) return;

    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      if (!mounted) return;

      // الإرسال نجح
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Email Sent',
        desc: 'Verification email has been sent successfully',
      ).show();

      // بعد إرسال ناجح → لا يوجد عدّ إضافي، الزر متاح مباشرة
      // فقط نعيد تحديث initialDelayDone لتأكيد أن الزر متاح
      setState(() {
        initialDelayDone = true;
        secondsLeft = 0;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = 'Something went wrong';
      int blockTime = 60; // البلوك لمدة دقيقة واحدة

      if (e.code == 'too-many-requests') {
        message =
            'Too many requests. Please wait 1 minute before trying again.';
        setState(() {
          isBlocked = true; // الزر معطّل لفترة قصيرة
        });
      }

      // يظهر فقط لو جاء خطأ من Firebase
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: message,
      ).show();

      // يبدأ عدّ البلوك
      startTimer(duration: blockTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: ((secondsLeft > 0 && !initialDelayDone) || isBlocked)
              ? Colors.grey
              : const Color.fromARGB(255, 4, 8, 68),
        ),
        child: Center(
          child: Text(
            isBlocked
                ? "Blocked: wait ${secondsLeft ~/ 60}m ${secondsLeft % 60}s"
                : ((secondsLeft > 0 && !initialDelayDone)
                    ? "Resend email in $secondsLeft s"
                    : "Resend email"),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
