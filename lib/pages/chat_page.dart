import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yummy/components/components.dart';
import 'package:yummy/providers.dart';

class ChatPage extends ConsumerWidget {
  ChatPage({super.key});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void sendMessage() {
      if (_messageController.text.trim().isNotEmpty) {
        final messageDao = ref.read(messageDaoProvider);
        messageDao.sendMessages(_messageController.text.trim());
        _messageController.clear();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final data = ref.watch(messageListProvider);
                return data.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      error.toString(),
                    ),
                  ),
                  data: (List<Message> messages) => ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) => MessageWidget(
                      message: messages[index],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Enter New Message',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                tooltip: 'Send',
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
