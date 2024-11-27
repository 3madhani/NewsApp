import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../home/daily_news.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Sliding Animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    // Start the sliding animation
    animationController.forward();

    // Navigate to the home screen after 3 seconds
    navigateToHome();
  }

  void navigateToHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(seconds: 6),
        () {
          if (mounted) {
            // Navigate to the auth route after the splash screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DailyNewsScreen(),
              ),
            );
          }
        },
      );
    });
  }

  @override
  void dispose() {
    animationController.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideTransition(
        position: slidingAnimation,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                textAlign: TextAlign.center,
                'NEWS APP',
                textStyle: const TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  wordSpacing: 3.0,
                  color: Color(0xFF000A54),
                  fontFamily: 'Horizon',
                ),
                speed: const Duration(milliseconds: 300),
              ),
            ],
            totalRepeatCount: 2,
            pause: const Duration(milliseconds: 500),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
        ),
      ),
    );
  }
}
