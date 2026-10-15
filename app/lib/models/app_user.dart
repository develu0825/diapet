/// 로그인 수단. 한국 반려동물 앱 기준 카카오·애플·이메일 + 둘러보기(게스트).
enum SignInMethod { kakao, apple, email, guest }

/// 인증된 사용자(최소 필드). 백엔드 연동 후 프로필·반려동물 정보가 붙는다.
class AppUser {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.method,
    this.email,
  });

  final String id;
  final String displayName;
  final SignInMethod method;
  final String? email;

  bool get isGuest => method == SignInMethod.guest;

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'email': email,
        'method': method.name,
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as String,
        displayName: (j['displayName'] as String?) ?? '사용자',
        email: j['email'] as String?,
        method: SignInMethod.values.firstWhere(
          (m) => m.name == j['method'],
          orElse: () => SignInMethod.guest,
        ),
      );
}
