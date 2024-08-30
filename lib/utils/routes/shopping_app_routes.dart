import 'package:flutter/material.dart';
import 'package:shopping_exam/screen/cart/view/cart_screen.dart';
import 'package:shopping_exam/screen/home/view/home_screen.dart';

import '../../screen/splash/view/splash_screen.dart';

Map<String,WidgetBuilder> shoppingAppRoutes={
  "/":(context) => const SplashScreen(),
  "home":(context) => HomeScreen(),
  "cart":(context) => CartScreen()
};