import 'package:flutter/material.dart';
import '../widgets/app_tab_bar.dart';
import 'home_dashboard.dart';
import 'memorial_screen.dart';
import 'my_screen.dart';
import 'vendor_list_screen.dart';

/// 메인 탭 셸 — 홈/장례/추모/마이를 [IndexedStack]으로 유지 전환.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = MainTab.home});

  final MainTab initialTab;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late MainTab _current = widget.initialTab;

  void _select(MainTab t) => setState(() => _current = t);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: MainTab.values.indexOf(_current),
          children: [
            HomeDashboard(onNavigateTab: _select),
            const VendorListScreen(),
            const MemorialScreen(),
            MyScreen(onNavigateTab: _select),
          ],
        ),
      ),
      bottomNavigationBar: AppTabBar(current: _current, onSelect: _select),
    );
  }
}
