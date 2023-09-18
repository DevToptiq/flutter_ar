import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:user_app/firebase_options.dart';
import 'package:user_app/pages/cart_page.dart';
import 'package:user_app/pages/checkout_page.dart';
import 'package:user_app/pages/launcher_page.dart';
import 'package:user_app/pages/login_page.dart';
import 'package:user_app/pages/order_page.dart';
import 'package:user_app/pages/order_success_page.dart';
import 'package:user_app/pages/otp_verification_page.dart';
import 'package:user_app/pages/product_details_page.dart';
import 'package:user_app/pages/promo_code_page.dart';
import 'package:user_app/pages/user_profile_page.dart';
import 'package:user_app/pages/view_product_page.dart';
import 'package:user_app/providers/cart_provider.dart';
import 'package:user_app/providers/order_provider.dart';
import 'package:user_app/providers/product_provider.dart';
import 'package:user_app/providers/user_provider.dart';

// TODO: Change the deepar.aar file with your own account file when working

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.toMap()}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM TOKEN: $fcmToken');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("promo");
  await FirebaseMessaging.instance.subscribeToTopic("user");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        ViewProductPage.routeName: (_) => const ViewProductPage(),
        ProductDetailsPage.routeName: (_) => ProductDetailsPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        UserProfilePage.routeName: (_) => const UserProfilePage(),
        OtpVerificationPage.routeName: (_) => const OtpVerificationPage(),
        CartPage.routeName: (_) => const CartPage(),
        CheckoutPage.routeName: (_) => const CheckoutPage(),
        OrderSuccessfulPage.routeName: (_) => const OrderSuccessfulPage(),
        PromoCodePage.routeName: (_) => const PromoCodePage(),
      },
    );
  }
}
