import 'package:flutter/material.dart';
import 'package:dopamind/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final Future<void> Function(String name, String email) onLogin;

  const AuthScreen({super.key, required this.onLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum AuthMode { login, signup, forgot }

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _mode = AuthMode.login;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (_mode == AuthMode.login || _mode == AuthMode.signup) {
      final name = _nameController.text.isNotEmpty
          ? _nameController.text
          : _emailController.text.split('@')[0];
      await widget.onLogin(name, _emailController.text);
    } else {
      setState(() => _mode = AuthMode.login);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    await widget.onLogin('User', 'user@gmail.com');
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mutedFg = isDark ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;
    final primary = theme.colorScheme.primary;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (_mode != AuthMode.login)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 24),
                      onPressed: () => setState(() => _mode = AuthMode.login),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            // Logo and title
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.psychology,
                      size: 36,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'DopamineOS',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI Digital Behavior Prediction',
                    style: theme.textTheme.bodySmall?.copyWith(color: mutedFg),
                  ),
                ],
              ),
            ),

            // Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildModeContent(theme, mutedFg, primary, border),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeContent(
      ThemeData theme, Color mutedFg, Color primary, Color border) {
    switch (_mode) {
      case AuthMode.login:
        return _buildLoginForm(theme, mutedFg, primary, border);
      case AuthMode.signup:
        return _buildSignupForm(theme, mutedFg, primary, border);
      case AuthMode.forgot:
        return _buildForgotForm(theme, mutedFg, primary, border);
    }
  }

  Widget _buildLoginForm(
      ThemeData theme, Color mutedFg, Color primary, Color border) {
    return KeyedSubtree(
      key: const ValueKey('login'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text(
              'Welcome back',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Sign in to continue your digital wellness journey',
              style: theme.textTheme.bodySmall?.copyWith(color: mutedFg),
            ),
            const SizedBox(height: 24),

            // Google Sign In
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                icon: Image.network(
                  'https://www.google.com/favicon.ico',
                  width: 20,
                  height: 20,
                  errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24),
                ),
                label: const Text('Continue with Google'),
              ),
            ),
            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: TextStyle(color: mutedFg, fontSize: 12)),
                ),
                Expanded(child: Divider(color: border)),
              ],
            ),
            const SizedBox(height: 24),

            // Email field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password field
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 8),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _mode = AuthMode.forgot),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: mutedFg, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign In button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 24),

            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ",
                    style: TextStyle(color: mutedFg, fontSize: 14)),
                GestureDetector(
                  onTap: () => setState(() => _mode = AuthMode.signup),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm(
      ThemeData theme, Color mutedFg, Color primary, Color border) {
    return KeyedSubtree(
      key: const ValueKey('signup'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text(
              'Create account',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Start your journey to healthier digital habits',
              style: theme.textTheme.bodySmall?.copyWith(color: mutedFg),
            ),
            const SizedBox(height: 24),

            // Name field
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              hint: 'Your name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            // Email field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password field
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Create a password',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 24),

            // Create Account button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Account'),
              ),
            ),
            const SizedBox(height: 24),

            // Sign in link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ',
                    style: TextStyle(color: mutedFg, fontSize: 14)),
                GestureDetector(
                  onTap: () => setState(() => _mode = AuthMode.login),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotForm(
      ThemeData theme, Color mutedFg, Color primary, Color border) {
    return KeyedSubtree(
      key: const ValueKey('forgot'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text(
              'Reset password',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              "We'll send you a link to reset your password",
              style: theme.textTheme.bodySmall?.copyWith(color: mutedFg),
            ),
            const SizedBox(height: 24),

            // Email field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),

            // Send Reset Link button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Reset Link'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !_showPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
