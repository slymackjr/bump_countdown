/*
import 'package:bump_countdown/screens/welcome_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onToggleTheme; // Added to allow theme toggling from splash screen

  const SplashScreen({super.key, required this.onToggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});

    if (mounted) {
      Navigator.pushReplacement(
        context,
        //MaterialPageRoute(builder: (context) => HomeScreen(onToggleTheme: widget.onToggleTheme)), // Pass the theme toggle callback to HomeScreen
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const Text(
              "Bump Countdown",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
*//*

import 'package:flutter/material.dart';
import 'package:bump_countdown/screens/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const SplashScreen({super.key, required this.onToggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logo1Animation;
  late Animation<Offset> _logo2Animation;
  late Animation<Offset> _logo3Animation;
  late Animation<Offset> _logo4Animation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animations for each logo part from their respective directions
    _logo1Animation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _logo2Animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _logo3Animation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _logo4Animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animations
    _controller.forward();

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Stack(
                children: [
                  // Logo part 1 (from top)
                  SlideTransition(
                    position: _logo1Animation,
                    child: Image.asset('images/logo-3.png', width: 200, height: 200),
                  ),
                  // Logo part 2 (from bottom)
                  SlideTransition(
                    position: _logo2Animation,
                    child: Image.asset('images/logo-1.png', width: 200, height: 200),
                  ),
                  // Logo part 3 (from left)
                  SlideTransition(
                    position: _logo3Animation,
                    child: Image.asset('images/logo-2.png', width: 200, height: 200),
                  ),
                  // Logo part 4 (from right, with words)
                  SlideTransition(
                    position: _logo4Animation,
                    child: Image.asset('images/logo-4.png', width: 200, height: 200),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:bump_countdown/screens/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const SplashScreen({super.key, required this.onToggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logo1Animation;
  late Animation<Offset> _logo2Animation;
  late Animation<Offset> _logo3Animation;
  late Animation<Offset> _logo4Animation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animations for each logo part from their respective directions
    _logo1Animation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _logo2Animation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _logo3Animation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _logo4Animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animations
    _controller.forward();

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Stack(
                children: [
                  // Logo part 1 (from top)
                  SlideTransition(
                    position: _logo1Animation,
                    child: Image.asset('images/logo-1.png', width: 300, height: 300),
                  ),
                  // Logo part 3 (from left) - Render this after logo-1.png
                  SlideTransition(
                    position: _logo3Animation,
                    child: Image.asset('images/logo-3.png', width: 300, height: 300),
                  ),
                  // Logo part 2 (from bottom)
                  SlideTransition(
                    position: _logo2Animation,
                    child: Image.asset('images/logo-2.png', width: 300, height: 300),
                  ),
                  // Logo part 4 (from right, with words)
                  SlideTransition(
                    position: _logo4Animation,
                    child: Image.asset('images/logo-4.png', width: 300, height: 300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
