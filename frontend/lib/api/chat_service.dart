import 'package:frontend/api/model/chat.dart';

abstract class PostService {
  Future<List<Chat>> getChats();

  Future<void> createChat();
}
