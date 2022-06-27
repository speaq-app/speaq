import 'dart:developer';

import 'package:fixnum/fixnum.dart';
import 'package:frontend/api/grpc/protos/post.pbgrpc.dart';
import 'package:frontend/api/model/post.dart';
import 'package:frontend/api/post_service.dart';
import 'package:frontend/utils/token_utils.dart';
import 'package:grpc/grpc.dart';

class GRPCPostService implements PostService {
  late PostClient _client;
  late CallOptions _callOptions;

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
      log(response.postList.elementAt(i).date.toString());
      postList.add(
        Post(
          id: response.postList.elementAt(i).postId.toInt(),
          resourceID: response.postList.elementAt(i).resourceId.toInt(),
          date: DateTime.fromMillisecondsSinceEpoch(
              response.postList.elementAt(i).date.toInt() * 1000,
              isUtc: true),
          description: response.postList.elementAt(i).description,
          ownerID: response.postList.elementAt(i).ownerId.toInt(),
          numberOfLikes: response.postList.elementAt(i).numberOfLikes.toInt(),
          numberOfComments:
              response.postList.elementAt(i).numberOfComments.toInt(),
          mimeType: response.postList.elementAt(i).resourceMimeType,
        ),
      );
    }

    return postList;
  }

  @override
  Future<void> createPost({
    required String description,
    String? resourceDataInBase64,
    String? resourceMimeType,
    Duration? audioDuration,
  }) async {
    await _client.createPost(
      CreatePostRequest()
        ..description = description
        ..resourceData = resourceDataInBase64 ?? ""
        ..resourceMimeType = resourceMimeType ?? ""
        ..audioDuration = Int64((audioDuration ?? Duration.zero).inMilliseconds),
      options: _callOptions,
    );
  }
}
