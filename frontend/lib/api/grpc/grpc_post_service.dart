import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/post.pbgrpc.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/api/post_service.dart';
import 'package:grpc/grpc.dart';

class GRPCPostService implements PostService {
  late PostClient _client;

  GRPCPostService(
    String ip, {
    int port = 443,
  }) {
    _client = PostClient(
      ClientChannel(
        ip,
        port: port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
    );
  }

  @override
  Future<Post> getPost(int id) async {
    GetPostResponse response = await _client.getPost(
      GetPostRequest()..id = Int64(id),
    );

    return Post(
      id: id,
      date: DateTime.parse(response.date),
      description: response.description,
      resourceID: response.resourceId.toInt(),
    );
  }

  @override
  Future<void> savePost({
    required int id,
    required Post post,
  }) async {
    await _client.createPost(CreatePostRequest()
      ..userId = Int64(id)
      ..description = post.description);
  }
}
