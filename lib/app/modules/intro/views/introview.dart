import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/introcontroller.dart';

class IntroView extends GetView<IntroController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFF1A1B2F),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Main Image with Gradient Overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Image
                Image.asset(
                  'assets/intro.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0xFF1A1B2F).withOpacity(0.5),
                        Color(0xFF1A1B2F).withOpacity(0.8),
                        Color(0xFF1A1B2F),
                      ],
                      stops: [0.3, 0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Text Content
                  Obx(() {
                    final currentData = controller.introPages[controller.currentPage.value];
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Column(
                        key: ValueKey<int>(controller.currentPage.value),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentData['title1']!,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              height: 1.2,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            currentData['title2']!,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              height: 1.2,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            currentData['description']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              fontFamily: 'Poppins',
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 32),
                  // Bottom Row with Page Indicator and Continue Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicator
                      Obx(() => Row(
                            children: List.generate(
                              controller.introPages.length,
                              (index) => Container(
                                margin: EdgeInsets.only(
                                    right: index < controller.introPages.length - 1
                                        ? 8
                                        : 0),
                                width:
                                    controller.currentPage.value == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                      controller.currentPage.value == index
                                          ? 1
                                          : 0.3),
                                  borderRadius: BorderRadius.circular(
                                      controller.currentPage.value == index
                                          ? 4
                                          : 4),
                                ),
                              ),
                            ),
                          )),
                      // Continue Button
                      ElevatedButton(
                        onPressed: () => controller.handleContinue(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}