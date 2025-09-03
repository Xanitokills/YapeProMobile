import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String)? onNavigate;

  const LoginScreen({super.key, this.onNavigate});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(_slideController);

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool validateEmail(String email) {
    const emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
    return RegExp(emailRegex).hasMatch(email);
  }

  Future<void> handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showAlert('Error', 'Por favor completa todos los campos');
      return;
    }

    if (!validateEmail(_emailController.text)) {
      _showAlert('Error', 'Por favor ingresa un email válido');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      debugPrint(
        'Login attempt: ${_emailController.text}, ${_passwordController.text}',
      );
      // Navegación al dashboard
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (error) {
      _showAlert('Error', 'Error al iniciar sesión. Intenta de nuevo.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void handleForgotPassword() {
    if (widget.onNavigate != null) {
      widget.onNavigate!('ForgotPassword');
    }
  }

  void handleSignUp() {
    if (widget.onNavigate != null) {
      widget.onNavigate!('SignUp');
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6C5CE7),
                  Color(0xFFA29BFE),
                  Color(0xFF74B9FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _fadeController,
                        _slideController,
                      ]),
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo/Header
                            Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 280,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Colors.white, Color(0xFFF8F9FA)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 4.65,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Y',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6C5CE7),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'YapePro',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Bienvenido de vuelta',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFE8E8E8),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),

                            // Form
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 2),
                                        blurRadius: 3.84,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                        color: Color(0xFF8E8E93),
                                        size: 20,
                                      ),
                                      hintText: 'Correo electrónico',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF8E8E93),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 2),
                                        blurRadius: 3.84,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          right: 12,
                                        ),
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF8E8E93),
                                          size: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            hintText: 'Contraseña',
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF8E8E93),
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 14,
                                                ),
                                          ),
                                          obscureText: !_showPassword,
                                          textCapitalization:
                                              TextCapitalization.none,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: const Color(0xFF8E8E93),
                                          size: 20,
                                        ),
                                        onPressed: () => setState(
                                          () => _showPassword = !_showPassword,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: handleForgotPassword,
                                    child: const Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 4.65,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isLoading
                                          ? const Color(0xFFBDC3C7)
                                          : Colors.white,
                                      foregroundColor: const Color(0xFF6C5CE7),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: _isLoading ? null : handleLogin,
                                    child: _isLoading
                                        ? const Text(
                                            'Iniciando sesión...',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Divider(
                                        color: Color(0xFFE8E8E8),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: const Text(
                                        'o continúa con',
                                        style: TextStyle(
                                          color: Color(0xFFE8E8E8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Divider(
                                        color: Color(0xFFE8E8E8),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () {},
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                        side: const BorderSide(
                                          color: Color(0xFFE8E8E8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.facebook,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () {},
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                        side: const BorderSide(
                                          color: Color(0xFFE8E8E8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.apple,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () {},
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                        side: const BorderSide(
                                          color: Color(0xFFE8E8E8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '¿No tienes cuenta? ',
                                      style: TextStyle(
                                        color: Color(0xFFE8E8E8),
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: handleSignUp,
                                      child: const Text(
                                        'Regístrate',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
  