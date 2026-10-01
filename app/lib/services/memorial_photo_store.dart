import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 추모 사진의 영속 저장소.
///
/// 고른 사진을 앱 전용 폴더로 **복사**해 보관하고(캐시는 사라질 수 있음),
/// 경로 목록(순서 포함)을 저장해 앱 재시작 후에도 마지막 상태를 복원한다.
class MemorialPhotoStore {
  static const _key = 'memorial_photo_paths';

  Future<Directory> _photoDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/memorial_photos');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// 저장된 사진을 순서대로 불러온다(실제 존재하는 파일만).
  /// 저장소 접근 실패(예: 테스트 환경) 시 빈 목록을 반환한다.
  Future<List<File>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paths = prefs.getStringList(_key) ?? const [];
      final files = <File>[];
      for (final path in paths) {
        final file = File(path);
        if (await file.exists()) files.add(file);
      }
      // 중간에 사라진 파일이 있었다면 목록을 정리해 다시 저장.
      if (files.length != paths.length) await _persist(files);
      return files;
    } catch (_) {
      return [];
    }
  }

  /// 새로 고른 사진들을 전용 폴더로 복사해 [current] 뒤에 추가하고 저장.
  Future<List<File>> addPicked(List<XFile> picked, List<File> current) async {
    final dir = await _photoDir();
    final result = List<File>.of(current);
    for (var i = 0; i < picked.length; i++) {
      final x = picked[i];
      final stamp = DateTime.now().microsecondsSinceEpoch;
      final dest = File('${dir.path}/mem_${stamp}_${i}_${x.name}');
      await File(x.path).copy(dest.path);
      result.add(dest);
    }
    await _persist(result);
    return result;
  }

  /// 순서가 바뀌거나 삭제됐을 때 현재 목록을 그대로 저장.
  Future<void> save(List<File> files) => _persist(files);

  Future<void> _persist(List<File> files) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, files.map((f) => f.path).toList());
  }
}
