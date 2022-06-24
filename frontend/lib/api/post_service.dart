import 'package:frontend/api/model/post.dart';

abstract class PostService {
  Future<List<Post>> getPosts(int id);

  Future<void> createPost({
    required String description,
    String resourceDataInBase64 = "",
    String resourceMimeType = "",
    Duration audioDuration = Duration.zero,
  });
}
