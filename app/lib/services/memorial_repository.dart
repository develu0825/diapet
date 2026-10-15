import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'memorial_photo_store.dart';

/// 추모 데이터(사진) 저장소 추상화.
///
/// 지금은 [LocalMemorialRepository] 가 기기 로컬([MemorialPhotoStore]: 앱 전용 폴더 +
/// shared_preferences)에만 보관한다. → **기기를 바꾸면 추모 사진이 사라진다.**
/// 실제 출시 때는 Firebase Storage 업로드 + Firestore 메타데이터로 동기화하는
/// `FirebaseMemorialRepository` 로 [memorialRepository] 한 줄만 교체하면,
/// 서버 백업·기기 간 동기화가 된다. (docs/BACKEND_SETUP.md)
///
/// 메서드는 로컬 파일([File]) 기준이라 서버 구현에서도 그대로 쓸 수 있다
/// (다운로드해 캐시한 파일을 돌려주고, 추가 시 업로드한다).
abstract class MemorialRepository {
  /// 저장된 추모 사진을 순서대로 불러온다.
  Future<List<File>> loadPhotos();

  /// 새로 고른 사진을 [current] 뒤에 추가하고 저장한 전체 목록을 돌려준다.
  Future<List<File>> addPhotos(List<XFile> picked, List<File> current);

  /// 순서 변경·삭제 후 현재 목록을 저장한다.
  Future<void> savePhotos(List<File> files);
}

class LocalMemorialRepository implements MemorialRepository {
  final MemorialPhotoStore _store = MemorialPhotoStore();

  @override
  Future<List<File>> loadPhotos() => _store.load();

  @override
  Future<List<File>> addPhotos(List<XFile> picked, List<File> current) =>
      _store.addPicked(picked, current);

  @override
  Future<void> savePhotos(List<File> files) => _store.save(files);
}

/// 전역 접근점. 백엔드 붙일 때 이 한 줄만 교체.
final MemorialRepository memorialRepository = LocalMemorialRepository();
