import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'models/booking_draft.dart';
import 'models/vendor.dart';
import 'screens/booking_screen.dart';
import 'screens/confirm_screen.dart';
import 'screens/crisis_screen.dart';
import 'screens/done_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/preneed_screen.dart';
import 'screens/quote_screen.dart';
import 'screens/vendor_detail_screen.dart';
import 'screens/vendor_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DiapetApp());
}

class DiapetApp extends StatelessWidget {
  const DiapetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diapet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: Routes.onboarding,
      routes: {
        Routes.onboarding: (_) => const OnboardingScreen(),
        Routes.homeShell: (_) => const HomeShell(),
        Routes.crisis: (_) => const CrisisScreen(),
        Routes.quote: (_) => const QuoteScreen(),
        Routes.vendorList: (_) => const Scaffold(
              body: SafeArea(child: VendorListScreen(showBack: true)),
            ),
        Routes.preneed: (_) => const PreneedScreen(),
      },
      // 인자를 전달받는 플로우 라우트.
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.vendorDetail:
            final vendor = settings.arguments as Vendor;
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => VendorDetailScreen(vendor: vendor),
            );
          case Routes.booking:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => BookingScreen(
                draft: settings.arguments as BookingDraft,
              ),
            );
          case Routes.confirm:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ConfirmScreen(
                draft: settings.arguments as BookingDraft,
              ),
            );
          case Routes.done:
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => DoneScreen(
                draft: settings.arguments as BookingDraft,
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
