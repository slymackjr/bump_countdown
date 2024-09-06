/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../misc/colors.dart';

class ResponsiveButton extends StatelessWidget {
  final bool? isResponsive;
  final double? width;
  const ResponsiveButton({super.key, this.width, this.isResponsive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.mainColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('images/button-5.svg', width: 50,),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../misc/colors.dart';

class ResponsiveButton extends StatelessWidget {
  final bool? isResponsive;
  final double? width;
  final VoidCallback onPressed;  // Add a VoidCallback for the button press

  const ResponsiveButton({
    super.key,
    this.width,
    this.isResponsive = false,
    required this.onPressed,  // Add the onPressed callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,  // Add the tap functionality
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.mainColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('images/button-5.svg', width: 50),
          ],
        ),
      ),
    );
  }
}
