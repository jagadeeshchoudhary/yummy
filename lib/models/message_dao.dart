import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yummy/components/components.dart';

import 'user_dao.dart';

class MessageDao {
  MessageDao({required this.userDao});
  final UserDao userDao;

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('messages');

  void sendMessages(String text) {
    final message = Message(
      date: DateTime.now(),
      email: userDao.email()!,
      text: text,
    );
    collection.add(message.toJson());
  }

  Stream<List<Message>> getMessageStream() {
    return collection.orderBy('date', descending: true).snapshots().map(
          (snapshot) => [...snapshot.docs.map(Message.fromSnapshot)],
        );
  }
}
