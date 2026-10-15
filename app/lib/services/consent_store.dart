import 'package:shared_preferences/shared_preferences.dart';

/// 약관·개인정보 동의 저장소.
///
/// 필수 동의(만 14세 이상·서비스 이용약관·개인정보 수집·이용)를 받은 시점과
/// 선택 항목(마케팅 수신)을 로컬에 기록한다. 약관을 개정하면 [version] 을 올려
/// 다음 실행 때 재동의를 받는다.
///
/// TODO(backend): 동의 이력은 분쟁 대비를 위해 서버에도 사용자 계정과 함께
/// 저장해야 한다(동의 버전·시각·IP). 지금은 로컬 기록만 한다.
class ConsentStore {
  static const _key = 'consent';
  static const version = 1;

  Future<bool> hasConsented() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('${_key}_version') == version;
    } catch (_) {
      return false;
    }
  }

  Future<bool> marketingOptIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('${_key}_marketing') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> save({required bool marketing}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('${_key}_version', version);
      await prefs.setBool('${_key}_marketing', marketing);
      await prefs.setString('${_key}_at', DateTime.now().toIso8601String());
    } catch (_) {
      // 저장 실패해도 이번 실행에서는 동의한 것으로 보고 진행한다.
    }
  }
}

final ConsentStore consentStore = ConsentStore();
