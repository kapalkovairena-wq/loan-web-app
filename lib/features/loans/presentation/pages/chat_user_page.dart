import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatUserPage extends StatefulWidget {
  const ChatUserPage({super.key});

  @override
  State<ChatUserPage> createState() => _ChatUserPageState();
}

class _ChatUserPageState extends State<ChatUserPage> {
  final supabase = Supabase.instance.client;
  String? activeConversationId;
  final controller = TextEditingController();

  Future<void> createConversation() async {
    final res = await supabase
        .from('chat_conversations')
        .insert({'user_id': supabase.auth.currentUser!.id})
        .select()
        .single();

    setState(() => activeConversationId = res['id']);
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    await supabase.from('chat_messages').insert({
      'conversation_id': activeConversationId,
      'sender_type': 'user',
      'sender_id': supabase.auth.currentUser!.id,
      'message': controller.text.trim(),
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (activeConversationId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Support")),
        body: Center(
          child: ElevatedButton(
            onPressed: createConversation,
            child: const Text("Nouvelle discussion"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chat support")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('chat_messages')
                  .stream(primaryKey: ['id'])
                  .eq('conversation_id', activeConversationId!)
                  .order('created_at'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[i];
                    final isUser = m['sender_type'] == 'user';

                    return Align(
                      alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          m['message'],
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration:
                  const InputDecoration(hintText: "Votre message"),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}
