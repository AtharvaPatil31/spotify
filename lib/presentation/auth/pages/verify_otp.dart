import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class VerifyOTPPage extends StatefulWidget {
  final String phoneNumber;

  const VerifyOTPPage({super.key, required this.phoneNumber});

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isOTPFilled = false;

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_checkOTPFilled);
    }
  }

  void _checkOTPFilled() {
    setState(() {
      _isOTPFilled = _controllers.every((c) => c.text.length == 1);
    });
  }

  Future<void> _submitOTP() async {
    if (!_isOTPFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete 4-digit OTP')),
      );
      return;
    }

    final otp = _controllers.map((c) => c.text).join();

    try {
      // Replace with your backend endpoint for OTP verification via Twilio
      final response = await http.post(
        Uri.parse('https://your-backend.com/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': widget.phoneNumber, 'otp': otp}),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verified!')),
        );
        // TODO: Navigate to Home/Dashboard
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final buttonColor = const Color(0xFF1DB954);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text('Enter the 4-digit OTP sent to', style: TextStyle(color: textColor, fontSize: 16)),
              const SizedBox(height: 5),
              Text(widget.phoneNumber, style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (i) {
                  return SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(fontSize: 24, color: textColor),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
                      onChanged: (val) {
                        if (val.isNotEmpty && i < 3) _focusNodes[i + 1].requestFocus();
                        else if (val.isEmpty && i > 0) _focusNodes[i - 1].requestFocus();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isOTPFilled ? _submitOTP : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Verify OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    super.dispose();
  }
}
