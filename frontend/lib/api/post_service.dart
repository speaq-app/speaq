import 'package:frontend/api/model/post.dart';

abstract class PostService {
  Future<List<Post>> getPosts(int id);

  Future<void> createPost({
    required String description,
    String? resourceData,
    String? resourceMimeType,
  });
}
