import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'verify_otp.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> sendOTP(String phoneNumber) async {
    try {
      final supabase = Supabase.instance.client;

      // Send OTP via Supabase
      await supabase.auth.signInWithOtp(
        phone: '+91$phoneNumber',
      );

      // Navigate to Verify OTP Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOTPPage(
            phoneNumber: '+91$phoneNumber',
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      Color textColor,
      Color hintColor,
      Color fillColor, {
        bool obscureText = false,
        Widget? suffixIcon,
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: hintColor, fontFamily: "Satoshi"),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        suffixIcon: suffixIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white70 : Colors.black54;
    final fillColor = isDark ? Colors.white10 : Colors.black12;
    final buttonColor = const Color(0xFF1DB954);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: SvgPicture.asset(AppVectors.logo, height: 60)),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor, fontFamily: "Satoshi"),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(_nameController, 'Full Name', textColor, hintColor, fillColor,
                    validator: (value) => value!.trim().isEmpty ? 'Full Name is required' : null),
                const SizedBox(height: 20),
                _buildTextField(_emailController, 'Email Address', textColor, hintColor, fillColor,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.trim().isEmpty ? 'Email is required' : null),
                const SizedBox(height: 20),
                _buildTextField(_phoneController, 'Phone Number', textColor, hintColor, fillColor,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Phone number required';
                      if (value.length != 10) return 'Phone number must be 10 digits';
                      return null;
                    }),
                const SizedBox(height: 20),
                _buildTextField(_passwordController, 'Create Password', textColor, hintColor, fillColor,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: hintColor),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) => value!.isEmpty ? 'Password is required' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sendOTP(_phoneController.text.trim());
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: buttonColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Get OTP', style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
