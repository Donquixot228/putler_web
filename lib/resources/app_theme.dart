import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData theme(){
  return ThemeData(
   textTheme: const TextTheme(
     headline6: TextStyle(
       fontFamily: 'TTNorms-Bold',
       fontSize: 48,
       color: AppColors.lightBlueColor,
     ),
     bodyText1: TextStyle(
       fontFamily: 'TTNorms-Bold',
       fontSize: 24,
       color: AppColors.whiteColor,
     ),
   )
  );
}