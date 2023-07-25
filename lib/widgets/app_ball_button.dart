import 'package:flutter/material.dart';
import 'package:surf_practice_magic_ball/core/magic_reply.dart';
import 'package:shake/shake.dart';
import 'package:surf_practice_magic_ball/core/service_finctions.dart';
import '../core/mock_data_repository.dart';

///Widget of MagicBallButton
class AppBallButton extends StatefulWidget {
  final void Function(String) callback;

  const AppBallButton({
    super.key,
    required this.callback
  });

  @override
  State<AppBallButton> createState() => _AppBallButtonState();
}

class _AppBallButtonState extends State<AppBallButton> with TickerProviderStateMixin{

  String inBallText = '';
  MockDataRepository mockDataRepository = MockDataRepository();
  Color shadowColor = Colors.transparent;
  double sizeOfButton = 0;
  bool waitingForReply = false;

  //Animation of levitating
  late final AnimationController _flyController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late Animation<Offset> _flyOffsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 0.05),
  ).animate(CurvedAnimation(
    parent: _flyController,
    curve: Curves.linear,
  ));

  //Animation of shaking on waiting for response state
  late final AnimationController _shakeController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..repeat(reverse: true);
  late Animation<Offset> _shakeOffsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _shakeController,
    curve: Curves.linear,
  ));

  late final ShakeDetector shakeDetector = ShakeDetector.waitForStart(
      onPhoneShake: onPressed
  );

  ///function of animation control
  void animationControl(bool isShaking) {
    _flyOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, isShaking ? 0 : 0.1),
    ).animate(CurvedAnimation(
      parent: _flyController,
      curve: Curves.linear,
    ));
    _shakeOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(isShaking ? 0.01 : 0, isShaking ? 0.01 : 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.linear,
    ));
  }

  ///function of erasing old values
  void eraseInBallText() {
    inBallText = '';
    shadowColor = Colors.black.withOpacity(0.7);
    sizeOfButton = getBallSize(context);
    animationControl(true);
    setState(() {});
  }

  ///function on buttonTap or phone shaking
  Future<void> onPressed () async {
    if(!waitingForReply) {
      waitingForReply = true;
      widget.callback('blue');
      eraseInBallText();

      MagicReply magicReply = await fetchMagicReply();
      inBallText = magicReply.reply;
      animationControl(false);

      if(inBallText.isEmpty) {
        shadowColor = Colors.red.withOpacity(0.9);
        widget.callback('red');
      } else {
        sizeOfButton = 0;
      }

      setState(() {});
      waitingForReply = false;
    }
  }

  @override
  void initState() {
    shakeDetector.startListening();
    super.initState();
  }

  @override
  void dispose() {
    _flyController.dispose();
    shakeDetector.stopListening();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _flyOffsetAnimation,
      child: SlideTransition(
        position: _shakeOffsetAnimation,
        child: SizedBox(
          height: getBallSize(context),
          width: getBallSize(context),
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
        ),
      ),
    );
  }

  ///widget containing shadow on error or buttonTap and reply text
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
                    color: shadowColor
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
