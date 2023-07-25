import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/core/magic_reply.dart';
import 'package:shake/shake.dart';
import '../core/mock_data_repository.dart';

class AppBallButton extends StatefulWidget {

  const AppBallButton({
    super.key,
  });

  @override
  State<AppBallButton> createState() => _AppBallButtonState();
}

class _AppBallButtonState extends State<AppBallButton> with TickerProviderStateMixin{

  String inBallText = '';
  MockDataRepository mockDataRepository = MockDataRepository();
  Color errorColor = Colors.transparent;
  double sizeOfButton = 0;
  bool waitingForReply = false;

  late final ShakeDetector shakeDetector = ShakeDetector.waitForStart(
      onPhoneShake: onPressed
  );

  void eraseInBallText() {
    inBallText = '';
    errorColor = Colors.black.withOpacity(0.7);
    sizeOfButton = getSize();
    setState(() {});
  }

  Future<void> onPressed () async {
    if(!waitingForReply) {
      waitingForReply = true;
      eraseInBallText();
      MagicReply magicReply = await fetchMagicReply();
      inBallText = magicReply.reply;
      if(inBallText.isEmpty) {
        errorColor = Colors.red.withOpacity(0.9);
      } else {
        sizeOfButton = 0;
      }
      setState(() {});
      waitingForReply = false;
    }
  }

  double getSize() => switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS =>  MediaQuery.of(context).size.width * 0.9,
    _ =>  MediaQuery.of(context).size.height * 0.6,
  };

  @override
  void initState() {
    shakeDetector.startListening();
    super.initState();
  }

  @override
  void dispose() {
    shakeDetector.stopListening();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getSize(),
      width: getSize(),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          image: DecorationImage(
              image:  AssetImage('assets/ball_full.png'),
              alignment: Alignment.center,
              fit: BoxFit.fill,
          ),
        ),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent
            ),
            child: getBall()
        ),
      ),
    );
  }

  Widget getBall () {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: sizeOfButton,
          height: sizeOfButton,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(sizeOfButton/2)),
              boxShadow: [
                BoxShadow(
                    blurRadius: sizeOfButton,
                    color: errorColor
                )
              ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            inBallText,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w400
            ),
          ),
        ),
      ]
    );
  }
}
