import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/presentation/auth/pages/signup_page.dart';

import '../bloc/theme_cubit.dart';
 // 👈 Make sure this path matches your project

class ChooseMode extends StatelessWidget {
  const ChooseMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.mode),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay for better text visibility
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: const Alignment(0, -0.6),
                    child: SvgPicture.asset(AppVectors.logo),
                  ),
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  "Choose Mode",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Satoshi",
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle
                const Text(
                  "Select how you want to experience Spotify",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: "Satoshi",
                  ),
                ),

                const SizedBox(height: 40),

                // Glass Mode Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🌙 Dark Mode Column
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<ThemeCubeit>()
                                .updateTheme(ThemeMode.dark);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter:
                              ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.nightlight_round,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Dark Mode",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Satoshi",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 95),

                    // ☀️ Light Mode Column
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<ThemeCubeit>()
                                .updateTheme(ThemeMode.light);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter:
                              ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.wb_sunny_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Light Mode",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Satoshi",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // Continue Button
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (BuildContext context)=> const SignUpSignIn()
                          )
                      );
                      // You can navigate to the next screen after theme is set
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Satoshi",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
