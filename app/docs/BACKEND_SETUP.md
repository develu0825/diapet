# 백엔드 연동 가이드 (인증 → 예약 → 추모 저장)

현재 앱은 **백엔드 없이 동작하는 목(mock) 상태**입니다. 인증·동의 플로우는 완성돼 있고,
`MockAuthService`가 로컬(shared_preferences)에 가짜 세션을 저장합니다. 실제 서비스로 넘어갈 때
아래 순서로 Firebase를 붙입니다. **핵심: 화면·플로우는 그대로 두고 서비스 구현체만 교체합니다.**

## 0. 전제 — 왜 Firebase인가
- Auth·Firestore(DB)·Storage(추모 사진)·FCM(기일/긴급 알림)을 한 SDK로 → 로드맵 3·4·7을 한 번에 커버.
- 리전은 **asia-northeast3(서울)** 로 생성(Firestore·Storage). 개인정보 **국외이전 동의** 문구를 약관에 포함(이미 동의 화면에 자리 있음).

## 1. Firebase 프로젝트 생성 · 연결
```bash
# 1) https://console.firebase.google.com 에서 프로젝트 생성 (리전 서울)
# 2) CLI 설치 후 연결
dart pub global activate flutterfire_cli
flutterfire configure   # android/ios 앱 등록 → lib/firebase_options.dart 생성
```

## 2. 의존성 추가 (pubspec.yaml)
```yaml
dependencies:
  firebase_core: ^3.x
  firebase_auth: ^5.x
  cloud_firestore: ^5.x
  firebase_storage: ^12.x
  firebase_messaging: ^15.x     # 7) 알림
  sign_in_with_apple: ^6.x      # 애플 로그인
  kakao_flutter_sdk_user: ^1.x  # 카카오 로그인
```
> ⚠ 이 패키지들을 추가하면 `flutterfire configure` 로 만든 `firebase_options.dart` 와
> 네이티브 설정(google-services.json / GoogleService-Info.plist)이 **반드시 있어야 빌드됩니다.**
> 그래서 지금은 추가하지 않았습니다. 위 1단계를 마친 뒤 추가하세요.

## 3. main.dart 초기화
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DiapetApp());
}
```

## 4. 인증 구현체 교체 (task 3 마무리)
`lib/services/auth_service.dart` 에 `FirebaseAuthService implements AuthService` 를 추가하고
맨 아래 한 줄만 바꿉니다:
```dart
// 변경 전
final AuthService authService = MockAuthService();
// 변경 후
final AuthService authService = FirebaseAuthService();
```
- 구글/애플/이메일 → `firebase_auth` 네이티브 지원.
- **카카오** → `firebase_auth` 기본 미지원. `kakao_flutter_sdk` 로 로그인 후, Cloud Functions 에서
  **커스텀 토큰**을 발급해 `signInWithCustomToken` 으로 연결(표준 패턴).
- `AppUser` 매핑: `FirebaseAuth.instance.currentUser` → `AppUser(id: uid, ...)`.
- 동의 이력(`ConsentStore`)도 Firestore `users/{uid}/consent` 에 버전·시각과 함께 저장(분쟁 대비).

## 5. 다음 단계 연동 지점 (task 2 · 4)
- **task 2 예약**: `Vendor.seed`(하드코딩) → Firestore `vendors` 컬렉션. 견적/예약은
  `bookings/{id}` 문서 + 상태(요청·확정·취소). 허가번호 검증 결과 필드 포함.
- **task 4 추모 저장**: `MemorialPhotoStore`(로컬) → Firebase Storage 업로드 +
  `users/{uid}/memorials/{petId}/photos` 메타데이터. 기기 교체·백업 대응.

## 교체 시 체크리스트
- [ ] `flutterfire configure` 완료, `firebase_options.dart` 생성
- [ ] 패키지 추가 후 `flutter pub get` · 네이티브 설정 파일 배치
- [ ] `FirebaseAuthService` 작성 → `authService` 한 줄 교체
- [ ] 카카오 커스텀 토큰용 Cloud Function 배포
- [ ] 약관 전문·개인정보처리방침 실제 문서로 교체(`consent_screen.dart` 의 `_showDoc`)
- [ ] 동의 이력 서버 저장
