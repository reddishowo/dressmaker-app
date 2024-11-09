import 'package:clothing_store/app/modules/order/bindings/order_binding.dart';
import 'package:clothing_store/app/modules/order/views/order_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/intro/bindings/introbinding.dart';
import '../modules/intro/views/introview.dart';
import '../modules/login/bindings/loginbinding.dart';
import '../modules/login/views/loginview.dart';
import '../modules/register/bindings/registerbinding.dart';
import '../modules/register/views/registerview.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INTRO;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRO,
      page: () => IntroView(),
      binding: IntroBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.JAHITBAJU,
      page: () => OrderView(),
      bindings: [
        OrderBinding(),
        HomeBinding(),
      ]
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
