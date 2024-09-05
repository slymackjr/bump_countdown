import 'package:flutter/material.dart';
import '../misc/colors.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_text.dart';
import '../widgets/responsive_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List images = [
    "image-one.jpeg",
    "image-two.jpeg",
    "image-three.jpeg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index){
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "images/${images[index]}"
                    ),
                  fit: BoxFit.cover,
                )
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppLargeText(text: "Pregnancy", color: AppColors.gold,),
                            const AppText(text: " Due Date", size: 30, color: AppColors.orange,),
                            const SizedBox(height: 20,),
                            Container(
                              width: 250,
                              child: const AppText(
                                  text: "Welcome!, Find out your pregnancy due date now! Plus, as a special bonus, you can enter the expected name and gender of your baby!",
                                  color: AppColors.textColor3
                              ),
                            ),
                            const SizedBox(height: 40,),
                            const ResponsiveButton(width: 100,),
                          ],
                        ),
                    Column(
                      children: List.generate(3, (indexDots){
                        return Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          width: 8,
                          height: index == indexDots ? 25 : 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: index == indexDots ?AppColors.mainColor : AppColors.mainColor.withOpacity(0.3)
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            );
      }),
    );
  }
}
