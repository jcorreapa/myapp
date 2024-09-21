import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/network/dio.dart';

final serviceProvider = Provider<PostService>((ref) {
  final dio = ref.watch(dioProvider);
  return PostService(dio);
});

class PostService {
  final Dio _dio;

  PostService(this._dio);

  Future<List<PostModel>> getPosts() async {
    final response = await _dio.get('/api/post');
    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      final posts = data.map(
        (post) {
          return PostModel.fromJson(post);
        },
      );
      return posts.toList();
    } else {
      throw Exception('Error al obtener las publicaciones');
    }
  }
}
