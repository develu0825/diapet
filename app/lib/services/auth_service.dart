import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

/// 인증 서비스 추상화.
///
/// 지금은 [MockAuthService]가 로컬(shared_preferences)에 가짜 세션을 저장해
/// **백엔드 없이도** 로그인 → 동의 → 홈 플로우가 그대로 동작한다.
/// 실제 출시 때는 이 인터페이스를 구현한 `FirebaseAuthService` 를 만들고
/// 파일 맨 아래 [authService] 한 줄만 교체하면 된다. (docs/BACKEND_SETUP.md)
abstract class AuthService {
  /// 현재 세션을 구독할 수 있는 알림체. 로그인/로그아웃 시 값이 바뀐다.
  ValueListenable<AppUser?> get authState;

  AppUser? get currentUser;

  /// 앱 시작 시 저장된 세션 복원(없으면 null 유지).
  Future<void> restore();

  /// 선택한 수단으로 로그인. 성공 시 [currentUser] 가 채워진다.
  Future<AppUser> signIn(SignInMethod method, {String? email, String? displayName});

  Future<void> signOut();
}

/// 백엔드 연동 전까지 쓰는 로컬 목(mock) 구현.
///
/// 실제 SDK 호출 자리마다 주석으로 교체 지점을 표시해 두었다.
class MockAuthService implements AuthService {
  static const _key = 'auth_user_v1';

  final ValueNotifier<AppUser?> _user = ValueNotifier<AppUser?>(null);

  @override
  ValueListenable<AppUser?> get authState => _user;

  @override
  AppUser? get currentUser => _user.value;

  @override
  Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        _user.value = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (_) {
      // 최초 실행·테스트 환경에서 저장소 접근 실패 → 비로그인 상태로 둔다.
    }
  }

  @override
  Future<AppUser> signIn(SignInMethod method, {String? email, String? displayName}) async {
    // TODO(backend): 여기서 실제 카카오/애플/Firebase SDK 를 호출하고
    // 반환된 uid·프로필로 AppUser 를 만든다. (지금은 목 사용자 생성)
    final user = AppUser(
      id: 'mock_${method.name}_${DateTime.now().millisecondsSinceEpoch}',
      displayName: displayName ?? _defaultName(method),
      email: email,
      method: method,
    );
    _user.value = user;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(user.toJson()));
    } catch (_) {
      // 저장 실패해도 세션은 메모리에 유지 → 현재 실행에서는 로그인 상태.
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    _user.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {/* 무시 */}
  }

  String _defaultName(SignInMethod m) => switch (m) {
        SignInMethod.kakao => '카카오 사용자',
        SignInMethod.apple => 'Apple 사용자',
        SignInMethod.email => '이메일 사용자',
        SignInMethod.guest => '둘러보는 중',
      };
}

/// 전역 접근점. 백엔드를 붙일 때 이 한 줄만 `FirebaseAuthService()` 로 교체한다.
final AuthService authService = MockAuthService();
