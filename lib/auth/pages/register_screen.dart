import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/custom_loading_dialog.dart';
import 'package:frontend/home/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/services/validation_service.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AuthProvider authProvider;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      context.showDialog(message: 'Signing up...');

      final result = await context.read<AuthProvider>().register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) context.hideDialog();

      result.match(
        (err) {
          context.showCustomSnackBar(message: err, type: SnackBarType.error);
        },
        (_) {
          final name = authProvider.authModel?.user.name ?? '';
          context.showCustomSnackBar(
            message: 'Welcome, $name',
            type: SnackBarType.success,
          );
          // context.go(AppRoutes.home);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
      );
    }
  }

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 4.h),
        _buildLoginForm(),
        SizedBox(height: 3.h),
        _buildRegisterButton(),
        SizedBox(height: 3.h),
        _buildSignUpOption(),
      ],
    ),
  );

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Create Account', style: Theme.of(context).textTheme.titleLarge),
      SizedBox(height: 1.h),
      Text(
        'Join us to start your journey',
        style: Theme.of(context).textTheme.titleSmall,
      ),
    ],
  );

  Widget _buildLoginForm() => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _nameController,
          hintText: 'Enter your name',
          prefixIcon: Icons.person,
          validator: ValidationService.nameValidation,
        ),
        SizedBox(height: 2.h),
        Text('Email', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _emailController,
          hintText: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          validator: ValidationService.emailValidation,
        ),
        SizedBox(height: 2.h),
        Text('Password', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          validator:
              (value) =>
                  ValidationService.passwordValidation(value, isLogin: false),
          onFieldSubmitted: (value) => _register(),
        ),
        SizedBox(height: 2.h),
        Text('Confirm Password', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _confirmPasswordController,
          hintText: 'Enter your password again',
          prefixIcon: Icons.lock,
          isPassword: true,
          validator:
              (value) => ValidationService.confirmPasswordValidation(
                value,
                _passwordController.text.trim(),
              ),
          onFieldSubmitted: (value) => _register(),
        ),
      ],
    ),
  );

  Widget _buildRegisterButton() {
    return Consumer<AuthProvider>(
      builder:
          (context, provider, child) => SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _register,
              child: const Text('Sign up'),
            ),
          ),
    );
  }

  Widget _buildSignUpOption() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Already have an account?"),
      TextButton(
        onPressed: () => authProvider.toggleLoginView(),
        child: const Text('Log in'),
      ),
    ],
  );
}
