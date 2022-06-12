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

    List<Post> postList = <Post>[
      //remove Items
      Post(id: 1, resourceID: 1, date: DateTime.now(), description: "test 1", ownerID: 1, numberOfLikes: 10, numberOfComments: 5),
      Post(id: 2, resourceID: 2, date: DateTime.now(), description: "test 2", ownerID: 1, numberOfLikes: 15, numberOfComments: 3),
      Post(id: 3, resourceID: 3, date: DateTime.now(), description: "test 3", ownerID: 1, numberOfLikes: 20, numberOfComments: 10),
    ];

    for (int i = 0; i < response.postList.length; i++) {
      log("Datetime of post: ${response.postList.elementAt(i).date}"); //remove

      postList.add(
        Post(
          id: response.postList.elementAt(i).postId.toInt(),
          resourceID: response.postList.elementAt(i).resourceId.toInt(),
          date: DateTime.fromMillisecondsSinceEpoch(response.postList.elementAt(i).date.toInt()),
          description: response.postList.elementAt(i).description,
          ownerID: response.postList.elementAt(i).ownerId.toInt(),
          numberOfLikes: response.postList.elementAt(i).numberOfLikes.toInt(),
          numberOfComments: response.postList.elementAt(i).numberOfComments.toInt(),
        ),
      );
    }

    return postList;
  }

  @override
  Future<void> createPost({
    required int id,
    required Post post,
  }) async {
    await _client.createPost(
      CreatePostRequest()
        ..ownerId = Int64(id)
        ..description = post.description,
    );
  }
}
