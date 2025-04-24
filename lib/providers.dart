import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yummy/components/components.dart';

import 'models/models.dart';

final userDaoProvider = ChangeNotifierProvider<UserDao>((ref) {
  return UserDao();
});

final messageDaoProvider = Provider<MessageDao>((ref) {
  return MessageDao(userDao: ref.watch(userDaoProvider));
});

final messageListProvider = StreamProvider<List<Message>>((ref) {
  final messageDao = ref.watch(messageDaoProvider);
  return messageDao.getMessageStream();
});
