import 'package:ceylonsphere/pages/Home_Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _showValidationErrors = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // If we get here, login was successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );

      // Navigate to the home page after successful login
      if (userCredential.user != null) {
        // Use pushReplacement to replace the login page in the navigation stack
        // This prevents the user from going back to the login page with the back button
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TravelApp()),
        );
      }

    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found with this email';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Incorrect password';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Invalid email format';
        } else if (e.code == 'user-disabled') {
          _errorMessage = 'This account has been disabled';
        } else if (e.code == 'too-many-requests') {
          _errorMessage = 'Too many attempts. Try again later';
        } else {
          _errorMessage = 'Login failed: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo-14.png',
                  height: 100,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003734),
                  ),
                ),
                const SizedBox(height: 25),
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                Form(
                  key: _formKey,
                  autovalidateMode: _showValidationErrors
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _emailController,
                        label: "Email",
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _passwordController,
                        label: "Password",
                        prefixIcon: Icons.lock,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003734)),
                      )
                          : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showValidationErrors = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            _signInWithEmailAndPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003734),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Or log in with",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      _buildSocialButtons(),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistrationPage()),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: Color(0xFF003734)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF003734)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF003734)),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your $label";
        }
        if (label == "Email" && !value.contains('@')) {
          return "Please enter a valid email";
        }
        if (label == "Password" && value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('assets/google-logo.png', _signInWithGoogle),
        const SizedBox(width: 30),
        _buildSocialButton('assets/facebook-logo.png', _signInWithFacebook),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(assetPath, height: 30),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    // Implement Google Sign-In here
    // This requires additional firebase_auth_oauth package
    setState(() {
      _errorMessage = 'Google sign-in not implemented yet.';
    });
  }

  Future<void> _signInWithFacebook() async {
    // Implement Facebook Sign-In here
    // This requires additional firebase_auth_oauth package
    setState(() {
      _errorMessage = 'Facebook sign-in not implemented yet.';
    });
  }
}