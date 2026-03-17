import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:site_admin_pannel/app/app_colors.dart';
import 'package:site_admin_pannel/widgets/custom_elevated_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool obscure = true;

  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    if (isLogin) {
      /// LOGIN API CALL
      debugPrint("Login: ${emailController.text}");
    } else {
      /// SIGNUP API CALL
      debugPrint("Signup: ${usernameController.text}");
    }
  }

  void googleAuth() {
    /// Google Auth logic
    debugPrint("Google login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _GlassCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _AuthIcon(),

                          const SizedBox(height: 20),

                          Text(
                            isLogin
                                ? "Sign in with email"
                                : "Create an account",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Bring your data, teams and ideas together",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 30),

                          if (!isLogin)
                            _InputField(
                              controller: usernameController,
                              icon: Icons.person,
                              hint: "Username",
                            ),

                          if (!isLogin) const SizedBox(height: 12),

                          _InputField(
                            controller: emailController,
                            icon: Icons.email_outlined,
                            hint: "Email",
                          ),

                          const SizedBox(height: 12),

                          _PasswordField(
                            controller: passwordController,
                            obscure: obscure,
                            toggle: () {
                              setState(() => obscure = !obscure);
                            },
                          ),

                          const SizedBox(height: 10),

                          if (isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          CustomElevatedButton(
                            text: isLogin ? "Get Started" : "Sign Up",
                            onTap: submit,
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("Or sign in with"),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialButton(
                                icon: Icons.g_mobiledata,
                                onTap: googleAuth,
                              ),
                              const SizedBox(width: 12),
                              _SocialButton(icon: Icons.facebook, onTap: () {}),
                              const SizedBox(width: 12),
                              _SocialButton(icon: Icons.apple, onTap: () {}),
                            ],
                          ),

                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: toggleMode,
                            child: Text(
                              isLogin
                                  ? "Don't have an account? Sign up"
                                  : "Already have an account? Login",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffa8d0ff), Color(0xffeaf4ff)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.white],
              stops: [.1, 1],
              begin: Alignment.topCenter,
            ),
            // color: Colors.white.withValues(alpha: .85),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                blurRadius: 36,
                color: Colors.black.withValues(alpha: .08),
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _AuthIcon extends StatelessWidget {
  const _AuthIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 12, color: Colors.black.withValues(alpha: .1)),
        ],
      ),
      child: const Icon(Icons.login, size: 28),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (v) => v!.isEmpty ? "Required field" : null,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: EdgeInsets.all(8),
        prefixIcon: Icon(icon, color: AppColors.black),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final bool obscure;
  final VoidCallback toggle;
  final TextEditingController controller;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      validator: (v) => v!.length < 6 ? "Password too short" : null,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44,
        width: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Icon(icon),
      ),
    );
  }
}
