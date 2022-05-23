import 'package:frontend/api/model/post.dart';

abstract class PostService {
  Future<Post> getPost(int id);
}
