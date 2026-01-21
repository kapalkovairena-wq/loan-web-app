import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatAdminPage extends StatefulWidget {
  const ChatAdminPage({super.key});

  @override
  State<ChatAdminPage> createState() => _ChatAdminPageState();
}

class _ChatAdminPageState extends State<ChatAdminPage> {
  final supabase = Supabase.instance.client;
  String? selectedConversationId;
  final controller = TextEditingController();

  Future<void> sendAdminMessage() async {
    if (controller.text.trim().isEmpty) return;

    await supabase.from('chat_messages').insert({
      'conversation_id': selectedConversationId,
      'sender_type': 'admin',
      'sender_id': supabase.auth.currentUser!.id,
      'message': controller.text.trim(),
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin – Chats")),
      body: Row(
        children: [
          // Conversations
          SizedBox(
            width: 300,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('chat_conversations')
                  .stream(primaryKey: ['id'])
                  .order('created_at'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                return ListView(
                  children: snapshot.data!.map((conv) {
                    return ListTile(
                      title: Text("User ${conv['user_id']}"),
                      selected: selectedConversationId == conv['id'],
                      onTap: () =>
                          setState(() => selectedConversationId = conv['id']),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Messages
          Expanded(
            child: selectedConversationId == null
                ? const Center(child: Text("Sélectionnez une discussion"))
                : Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: supabase
                        .from('chat_messages')
                        .stream(primaryKey: ['id'])
                        .eq('conversation_id', selectedConversationId!)
                        .order('created_at'),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      return ListView(
                        children: snapshot.data!.map((m) {
                          final isAdmin =
                              m['sender_type'] == 'admin';
                          return Align(
                            alignment: isAdmin
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isAdmin
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Text(
                                m['message'],
                                style: TextStyle(
                                    color: isAdmin
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            hintText: "Réponse admin"),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendAdminMessage,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
