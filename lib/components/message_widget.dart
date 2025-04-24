import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yummy/components/components.dart';
import 'package:yummy/providers.dart';
import 'package:intl/intl.dart';

class MessageWidget extends ConsumerWidget {
  const MessageWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDao = ref.watch(userDaoProvider);
    final myMessage = userDao.email() == message.email;
    return FractionallySizedBox(
      widthFactor: 0.7,
      alignment: myMessage ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        crossAxisAlignment:
            myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 0, top: 16, left: 16, right: 16),
            child: Row(
              mainAxisAlignment:
                  myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                myMessage ? const Text('') : Text(message.email),
                const Spacer(),
                Text(
                  '${DateFormat.yMd().format(message.date)} ${DateFormat.Hm().format(message.date)}',
                )
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
