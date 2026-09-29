import 'package:flutter/material.dart';
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
      home: const _ThemePlaceholder(),
    );
  }
}

/// 라우팅·화면 이식 전까지 테마 확인용 임시 화면.
class _ThemePlaceholder extends StatelessWidget {
  const _ThemePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Diapet', style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}
