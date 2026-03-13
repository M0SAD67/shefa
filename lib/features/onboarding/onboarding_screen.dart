import 'package:flutter/material.dart';

import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = 'OnboardingScreen';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Alignment _animationAlignment = Alignment.center;

  final List<Widget> pages = [
    Center(child: Image.asset(AssetsApp.icOnboard1, fit: BoxFit.contain)),
    Center(child: Image.asset(AssetsApp.icOnboard2, fit: BoxFit.contain)),
    Center(child: Image.asset(AssetsApp.icOnboard3, fit: BoxFit.contain)),
  ];
  final List<String> titles = [
    AssetsApp.icOnboardTitle1,
    AssetsApp.icOnboardTitle2,
    AssetsApp.icOnboardTitle3,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index, Alignment alignment) {
    if (index >= 0 && index < pages.length) {
      setState(() {
        _animationAlignment = alignment;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.appLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              SizedBox(
                height: 344,
                width: 344,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  reverseDuration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          alignment: _animationAlignment,
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: Center(
                    key: ValueKey<int>(_currentPage),
                    child: pages[_currentPage],
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                reverseDuration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInCubic,
                layoutBuilder:
                    (Widget? currentChild, List<Widget> previousChildren) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[...previousChildren, ?currentChild],
                      );
                    },
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    alignment: _animationAlignment,
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Padding(
                  key: ValueKey<int>(_currentPage),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    titles[_currentPage],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ColorApp.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (_currentPage > 0) {
                        _navigateToPage(_currentPage - 1, Alignment.bottomLeft);
                      }
                    },
                    child: PageViewOnboard(
                      title: _currentPage == 0 ? "Skip" : "Previous",
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (_currentPage < pages.length - 1) {
                        _navigateToPage(
                          _currentPage + 1,
                          Alignment.bottomRight,
                        );
                      } else {
                        // Start logic
                      }
                    },
                    child: PageViewOnboard(
                      title: _currentPage < pages.length - 1 ? "Next" : "Start",
                    ),
                  ),
                ],
              ),
              // Hidden PageView for scroll synchronization if needed,
              // or we can just keep the indices synced.
              // We'll hide the PageView to use manual animation only for the "emerge" effect.
              SizedBox(
                height: 30,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    if (_animationAlignment == Alignment.center) {
                      setState(() {
                        _currentPage = index;
                      });
                    } else {
                      setState(() {
                        _currentPage = index;
                        // Reset alignment after manual trigger
                        Future.delayed(const Duration(milliseconds: 400), () {
                          if (mounted) _animationAlignment = Alignment.center;
                        });
                      });
                    }
                  },
                  itemBuilder: (context, index) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageViewOnboard extends StatelessWidget {
  const PageViewOnboard({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 55,
      decoration: BoxDecoration(
        color: ColorApp.buttonDetails,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: ColorApp.secondary,
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: ColorApp.appAmoled,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
