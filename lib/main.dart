import 'package:ceylonsphere/splash_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:async';
import 'pages/Payment_Pages/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Set up Firebase Auth state persistence
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  try {
    // Set Stripe publishable key
    Stripe.publishableKey = stripePublishableKey;
    await Stripe.instance.applySettings();
    print('Stripe initialized successfully');
  } catch (e) {
    print('Failed to initialize Stripe: $e');
  }

  // Run the app
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ceylon Sphere',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF004D40),
        brightness: Brightness.light,
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the snapshot has user data, then the user is logged in
          if (snapshot.hasData) {
            return const SplashScreen(isUserLoggedIn: true);
          }

          // Otherwise, the user is not logged in
          return const SplashScreen(isUserLoggedIn: false);
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool isUserLoggedIn;

  const SplashScreen({
    super.key,
    this.isUserLoggedIn = false,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final String _slogan = "discover sri lanka like never before";
  String _displayedSlogan = "";
  int _currentIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Create slide animation
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Start typing animation after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      _startTypingAnimation();
    });

    // Navigate to appropriate screen after delay
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (_currentIndex < _slogan.length) {
        setState(() {
          _displayedSlogan = _slogan.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        _typingTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF004D40),
              Color(0xFF004D40),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo without text (bigger size)
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/Logo-12.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Typing animation for slogan
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: child,
                      );
                    },
                    child: Text(
                      _displayedSlogan,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Text',
                        color: Color(0xFFF1F1F1),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // iOS-style loading indicator
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: child,
                      );
                    },
                    child: const CupertinoActivityIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}