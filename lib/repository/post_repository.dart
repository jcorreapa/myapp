import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/services/post_service.dart';

final respositoryProvider = Provider<PostRepository>((ref) {
  final service = ref.watch(serviceProvider);
  return PostRepository(service);
});

class PostRepository {
  final PostService _service;
  PostRepository(this._service);

  Future<List<PostModel>> getPosts() async {
    try {
      final posts = await _service.getPosts();
      return posts;
    } catch (e) {
      return [];
    }
  }
}
