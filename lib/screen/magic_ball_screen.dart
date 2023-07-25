import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/core/service_finctions.dart';
import 'package:surf_practice_magic_ball/widgets/app_ball_button.dart';

class MagicBallScreen extends StatefulWidget {
  const MagicBallScreen({
    super.key
  });

  @override
  State<MagicBallScreen> createState() => _MagicBallScreenState();
}

class _MagicBallScreenState extends State<MagicBallScreen> {

  String shadowColor = 'blue';

  void errorShadowColor (String errorMessage) {
    shadowColor = errorMessage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff100c2b),
              Colors.black
            ]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 180),
                  AppBallButton(callback: errorShadowColor)
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/${shadowColor}_ball_shadow.png',
                    width: getBallSize(context) * 0.8,
                  ),
                  const SizedBox(height: 60),
                  const Text(
                    'Нажмите на шар или потрясите телефон',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xff727272)
                    ),
                  ),
                  const SizedBox(height: 56)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
