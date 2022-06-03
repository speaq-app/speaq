import 'package:frontend/api/model/post.dart';

abstract class PostService {
  Future<Post> getPost(int id);

  Future<void> createPost({
    required int id,
    required Post post,
  });
}
