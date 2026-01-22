import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatAdminPage extends StatefulWidget {
  const ChatAdminPage({super.key});

  @override
  State<ChatAdminPage> createState() => _ChatAdminPageState();
}

class _ChatAdminPageState extends State<ChatAdminPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  String? selectedConversationId;

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void dispose() {
    _typingTimer?.cancel();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /* ---------------- TYPING ADMIN ---------------- */

  void _onAdminTyping(String value) {
    if (selectedConversationId == null) return;

    if (!_isTyping) {
      _isTyping = true;
      supabase.from('chat_typing').upsert({
        'conversation_id': selectedConversationId,
        'is_admin_typing': true,
      });
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _isTyping = false;
      supabase.from('chat_typing').upsert({
        'conversation_id': selectedConversationId,
        'is_admin_typing': false,
      });
    });
  }

  /* ---------------- SEND MESSAGE ---------------- */

  Future<void> sendAdminMessage() async {
    if (selectedConversationId == null ||
        controller.text.trim().isEmpty) return;

    _typingTimer?.cancel();
    _isTyping = false;

    await supabase.from('chat_typing').upsert({
      'conversation_id': selectedConversationId,
      'is_admin_typing': false,
    });

    await supabase.from('chat_messages').insert({
      'conversation_id': selectedConversationId!,
      'sender_type': 'admin',
      'sender_firebase_uid': null,
      'message': controller.text.trim(),
    });

    controller.clear();

    await Future.delayed(const Duration(milliseconds: 100));
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String formatTime(String isoDate) {
    final date = DateTime.parse(isoDate).toLocal();
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin – Chats")),
      body: Row(
        children: [
          /* ================= CONVERSATIONS ================= */
          SizedBox(
            width: 320,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('chat_conversations')
                  .stream(primaryKey: ['id'])
                  .order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final conversations = snapshot.data!;
                if (conversations.isEmpty) {
                  return const Center(child: Text("Aucune discussion"));
                }

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conv = conversations[index];
                    final isSelected =
                        selectedConversationId == conv['id'];

                    return ListTile(
                      selected: isSelected,
                      title: Text(
                        "User ${conv['firebase_uid']}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        conv['status'] ?? 'open',
                        style: TextStyle(
                          color: conv['status'] == 'closed'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedConversationId = conv['id'];
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),

          /* ================= MESSAGES ================= */
          Expanded(
            child: selectedConversationId == null
                ? const Center(
              child: Text(
                "Sélectionnez une discussion",
                style: TextStyle(fontSize: 16),
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: supabase
                        .from('chat_messages')
                        .stream(primaryKey: ['id'])
                        .eq('conversation_id',
                        selectedConversationId!)
                        .order('created_at', ascending: false),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!;

                      return ListView.builder(
                        reverse: true,
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final m = messages[index];
                          final isAdmin =
                              m['sender_type'] == 'admin';

                          return Align(
                            alignment: isAdmin
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isAdmin
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: isAdmin
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m['message'],
                                    style: TextStyle(
                                      color: isAdmin
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatTime(m['created_at']),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isAdmin
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                /* -------- USER TYPING -------- */
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: supabase
                      .from('chat_typing')
                      .stream(primaryKey: ['conversation_id'])
                      .eq('conversation_id',
                      selectedConversationId!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final isUserTyping =
                        snapshot.data!.first['is_user_typing'] ==
                            true;

                    return isUserTyping
                        ? const Padding(
                      padding: EdgeInsets.only(
                          left: 12, bottom: 6),
                      child: Text(
                        "Utilisateur est en train d’écrire…",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    )
                        : const SizedBox.shrink();
                  },
                ),

                /* ================= INPUT ================= */
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                      top:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onChanged: _onAdminTyping,
                          onSubmitted: (_) => sendAdminMessage(),
                          decoration: const InputDecoration(
                            hintText: "Réponse admin...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.green,
                        onPressed: sendAdminMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
