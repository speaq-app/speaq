import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/post.pbgrpc.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/api/post_service.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

class GRPCPostService implements PostService {
  late PostClient _client;
  late CallOptions _callOptions;

  GRPCPostService(ClientChannelBase channel) {
    _client = PostClient(channel);
    var token = TokenUtils.getToken();
    _callOptions = CallOptions(metadata: {"authorization": "bearer $token"});
  }

  @override
  Future<List<Post>> getPosts(int id) async {
    GetPostFeedResponse response = await _client.getPostFeed(
      GetPostFeedRequest(),
      options: _callOptions,
    );

    List<Post> postList = <Post>[];

    for (int i = 0; i < response.postList.length; i++) {
      var post = response.postList.elementAt(i);
      postList.add(
        Post(
          id: post.postId.toInt(),
          resourceID: post.resourceId.toInt(),
          date: DateTime.fromMillisecondsSinceEpoch(post.date.toInt() * 1000,
              isUtc: true),
          description: post.description,
          ownerID: post.ownerId.toInt(),
          numberOfLikes: post.numberOfLikes.toInt(),
          numberOfComments: post.numberOfComments.toInt(),
          resourceMimeType: post.resourceMimeType,
          resourceBlurHash: post.resourceBlurHash,
        ),
      );
    }

    return postList;
  }

  @override
  Future<void> createPost({
    required String description,
    List<int>? resourceData,
    String? resourceMimeType,
    Duration? audioDuration,
  }) async {
    await _client.createPost(
      CreatePostRequest()
        ..description = description
        ..resourceData = resourceData ?? <int>[]
        ..resourceMimeType = resourceMimeType ?? ""
        ..audioDuration =
            Int64((audioDuration ?? Duration.zero).inMilliseconds),
      options: _callOptions,
    );
  }
}
