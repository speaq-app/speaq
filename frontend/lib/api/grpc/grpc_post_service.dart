import 'dart:developer';

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
        options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
    );
  }

  @override
  Future<List<Post>> getPosts(int id) async {
    GetPostsResponse response = await _client.getPosts(GetPostsRequest()..userId = Int64(id));

    List<Post> postList = <Post>[];

    for (int i = 0; i < response.postList.length; i++) {
      //DateTime Convertion not correct!
      log(response.postList.elementAt(i).date.toString());
      postList.add(
        Post(
          id: response.postList.elementAt(i).postId.toInt(),
          resourceID: response.postList.elementAt(i).resourceId.toInt(),
          //date: DateTime.parse(response.postList.elementAt(i).date.toString()),
          date: DateTime.fromMillisecondsSinceEpoch(response.postList.elementAt(i).date.toInt() * 1000, isUtc: true),
          description: response.postList.elementAt(i).description,
          ownerID: response.postList.elementAt(i).ownerId.toInt(),
          numberOfLikes: response.postList.elementAt(i).numberOfLikes.toInt(),
          numberOfComments: response.postList.elementAt(i).numberOfComments.toInt(),
          ownerName: response.postList.elementAt(i).ownerName,
          ownerUsername: response.postList.elementAt(i).ownerUsername,
        ),
      );
    }

    return postList;
  }

  @override
  Future<void> createPost({required int ownerId, required Post post}) async {
    await _client.createPost(
      CreatePostRequest()
        ..ownerId = Int64(ownerId)
        ..description = post.description,
    );
  }
}
