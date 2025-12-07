// lib/views/otp_view.dart

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../controllers/otp_controller.dart';

class OtpView extends StatefulWidget {
  final String email; // Menerima email dari halaman sebelumnya

  const OtpView({super.key, required this.email});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  late final OtpController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OtpController();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final Color backgroundColor = const Color(0xFFF0EBE3);
  final Color primaryColor = const Color(0xFF006A4E);
  final Color textColor = const Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    // Tema untuk kotak Pinput
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => _controller.goBack(context),
                ),
              ),
              const SizedBox(height: 30),
              
              Text(
                'Please check your email',
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),

              RichText(
                text: TextSpan(
                  style: TextStyle(fontFamily: 'Poppins', color: textColor.withOpacity(0.7), fontSize: 16),
                  children: [
                    const TextSpan(text: 'We\'ve sent a code to '),
                    TextSpan(
                      text: widget.email, // Menampilkan email dari halaman sebelumnya
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Widget Pinput untuk OTP
              Center(
                child: Pinput(
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.white),
                    ),
                  ),
                  onCompleted: (pin) => _controller.verifyCode(context, pin),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // Logika verifikasi bisa juga dipicu dari sini
                  },
                  child: const Text('Verify', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Teks "Send code again" dengan timer
              Center(
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return TextButton(
                      onPressed: _controller.canResend ? _controller.resendCode : null,
                      child: Text(
                        _controller.canResend
                          ? 'Send code again'
                          : 'Send code again 00:${_controller.countdown.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: _controller.canResend ? primaryColor : Colors.grey,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}