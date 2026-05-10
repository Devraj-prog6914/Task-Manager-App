import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> handleSignIn() async {
    setState(() => isLoading = true);
    final user = await _authService.signInWithGoogle();

    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F1FF), Color(0xFFFFFFFF), Color(0xFFE0EEFF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 100, left: 40, child: _buildBgCircle(40)),
            Positioned(bottom: 150, right: 30, child: _buildBgCircle(60)),
            Positioned(
              top: 250,
              right: 50,
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFFD1E3FF),
                size: 40,
              ),
            ),

            Center(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.08),
                        blurRadius: 40,
                        spreadRadius: 10,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF90CAF9), Color(0xFF1E88E5)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "Tasks Manager",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0D47A1),
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        "Keep track of your daily routines\nand stay organized.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 45),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            side: BorderSide(
                              color: Colors.blue.shade100,
                              width: 1.2,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blue,
                                  ),
                                )
                              : const Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: Color(0xFF1565C0),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD1E3FF), width: 2),
      ),
    );
  }
}
