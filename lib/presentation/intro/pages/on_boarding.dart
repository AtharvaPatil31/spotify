import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/core/configs/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';

import '../../choose_mode/pages/choose_mode.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  double _pageOffset = 0.0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Millions of songs. Free on Spotify",
      description: "Listen to your favorite artists and discover new music.",
      image: AppImages.introBG,
    ),
    OnboardingData(
      title: "Create your own playlists",
      description: "Build your perfect music collection and share with friends.",
      image: AppImages.introBG_one,
    ),
    OnboardingData(
      title: "Enjoy music anywhere, anytime",
      description: "Download and listen offline. No internet needed.",
      image: AppImages.introBG_two,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  void _nextPage() {
    if (_pageOffset < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/getstarted');
    }
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, index) => _buildPage(_pages[index]),
          ),

          // Spotify-style indicator
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Center(child: _buildSpotifyIndicator()),
          ),

          // Buttons
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: _pageOffset >= _pages.length - 1
                ? Center(
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const ChooseMode()
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Satoshi"
                    ),

                  ),
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _skipOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Satoshi"
                      ),
                    ),
                  ),
                ),

                // Next
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Satoshi"
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(data.image),
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: const Alignment(0, -0.6),
                child: SvgPicture.asset(AppVectors.logo),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:
              const EdgeInsets.only(bottom: 250, left: 40, right: 40),
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Spotify-style dynamic indicator
  Widget _buildSpotifyIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        double fill = (_pageOffset - index + 1).clamp(0.0, 1.0);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 20,
          height: 4,
          decoration: BoxDecoration(
            color: Color.lerp(
              Colors.white.withOpacity(0.3),
              const Color(0xFF1DB954),
              fill,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}
