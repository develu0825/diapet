import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../widgets/app_tab_bar.dart';
import 'home_dashboard.dart';

/// 메인 탭 셸 — 홈/장례/추모/마이를 [IndexedStack]으로 유지 전환.
///
/// 각 탭 본문은 해당 기능 커밋에서 실제 화면으로 교체한다(현재 자리표시자).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = MainTab.home});

  final MainTab initialTab;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late MainTab _current = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: MainTab.values.indexOf(_current),
          children: [
            HomeDashboard(
              onNavigateTab: (t) => setState(() => _current = t),
            ),
            const _TabPlaceholder(tab: MainTab.funeral),
            const _TabPlaceholder(tab: MainTab.memorial),
            const _TabPlaceholder(tab: MainTab.my),
          ],
        ),
      ),
      bottomNavigationBar: AppTabBar(
        current: _current,
        onSelect: (t) => setState(() => _current = t),
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.tab});

  final MainTab tab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${tab.label} (준비 중)', style: AppText.h2),
    );
  }
}
