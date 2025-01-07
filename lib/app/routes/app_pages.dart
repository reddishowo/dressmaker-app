import 'package:clothing_store/app/middlewares/auth_middleware.dart';
import 'package:clothing_store/app/modules/about/bindings/about_bindings.dart';
import 'package:clothing_store/app/modules/about/views/about_views.dart';
import 'package:clothing_store/app/modules/account/bindings/account_bindings.dart';
import 'package:clothing_store/app/modules/account/views/account_views.dart';
import 'package:clothing_store/app/modules/admin/bindings/admin_dashboard_binding.dart';
import 'package:clothing_store/app/modules/admin/views/admin_dashboard_view.dart';
import 'package:clothing_store/app/modules/check/bindings/check_order_binding.dart';
import 'package:clothing_store/app/modules/check/views/check_order_view.dart';
import 'package:clothing_store/app/modules/feedback/bindings/feedback_binding.dart';
import 'package:clothing_store/app/modules/feedback/views/feedback_view.dart';
import 'package:clothing_store/app/modules/measurement/bindings/measurement_binding.dart';
import 'package:clothing_store/app/modules/measurement/views/measurement_view.dart';
import 'package:clothing_store/app/modules/order/bindings/order_binding.dart';
import 'package:clothing_store/app/modules/order/views/order_view.dart';
import 'package:clothing_store/app/modules/payment/bindings/payment_binding.dart';
import 'package:clothing_store/app/modules/payment/views/payment_view.dart';
import 'package:clothing_store/app/modules/profiles/bindings/profile_binding.dart';
import 'package:clothing_store/app/modules/profiles/views/profile_view.dart';
import 'package:clothing_store/app/modules/search/bindings/search_binding.dart'; // Import SearchBinding
import 'package:clothing_store/app/modules/search/views/search_view.dart'; // Import SearchView
import 'package:clothing_store/app/modules/voucher/bindings/voucher_binding.dart';
import 'package:clothing_store/app/modules/voucher/views/voucher_view.dart';
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
    GetPage(name: _Paths.JAHITBAJU, page: () => OrderView(), bindings: [
      OrderBinding(),
      HomeBinding(),
    ]),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/admin/dashboard',
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.CHECK,
      page: () => CheckOrderView(),
      binding: CheckOrderBinding(),
    ),
    GetPage(
      name: _Paths.MEASUREMENTS,
      page: () => MeasurementView(),
      binding: MeasurementBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => AccountSettingsView(),
      binding: AccountSettingsBinding(),
    ),
    // Route baru untuk SearchView
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.VOUCHER,
      page: () => VoucherView(),
      binding: VoucherBinding(),
    ),
  ];
}
