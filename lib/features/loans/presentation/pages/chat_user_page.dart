import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatUserPage extends StatefulWidget {
  const ChatUserPage({super.key});

  @override
  State<ChatUserPage> createState() => _ChatUserPageState();
}

class _ChatUserPageState extends State<ChatUserPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;

  String? activeConversationId;

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _refreshTimer;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    loadLastConversation();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _refreshTimer?.cancel();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) setState(() {});
      },
    );
  }

  /* ---------------- CONVERSATION ---------------- */

  Future<void> loadLastConversation() async {
    final res = await supabase
        .from('chat_conversations')
        .select('id')
        .eq('firebase_uid', firebaseUid)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (res != null) {
      setState(() => activeConversationId = res['id']);
      await markMessagesReadByUser();
    }
  }

  Future<void> markMessagesReadByUser() async {
    if (activeConversationId == null) return;

    await supabase
        .from('chat_messages')
        .update({
      'read_by_user': true,
      'read_at': DateTime.now().toIso8601String(),
    })
        .eq('conversation_id', activeConversationId!)
        .eq('sender_type', 'admin')
        .eq('read_by_user', false);
  }

  void onNewMessage(Map message) {
    if (message['sender_type'] == 'admin') {
      markMessagesReadByUser();
    }
  }

  Future<void> createNewConversation() async {
    final res = await supabase
        .from('chat_conversations')
        .insert({'firebase_uid': firebaseUid})
        .select('id')
        .single();

    setState(() => activeConversationId = res['id']);
  }

  /* ---------------- TYPING USER ---------------- */

  void _onUserTyping(String value) {
    if (activeConversationId == null) return;

    if (!_isTyping) {
      _isTyping = true;
      supabase.from('chat_typing').upsert({
        'conversation_id': activeConversationId,
        'is_user_typing': true,
      });
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _isTyping = false;
      supabase.from('chat_typing').upsert({
        'conversation_id': activeConversationId,
        'is_user_typing': false,
      });
    });
  }

  /* ---------------- SEND MESSAGE ---------------- */

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty || activeConversationId == null) return;

    _typingTimer?.cancel();
    _isTyping = false;

    await supabase.from('chat_typing').upsert({
      'conversation_id': activeConversationId,
      'is_user_typing': false,
    });

    await supabase.from('chat_messages').insert({
      'conversation_id': activeConversationId!,
      'sender_type': 'user',
      'sender_firebase_uid': firebaseUid,
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
    if (activeConversationId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Support")),
        body: Center(
          child: ElevatedButton(
            onPressed: createNewConversation,
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
                  .order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                if (messages.isNotEmpty) {
                  onNewMessage(messages.first);
                }

                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[i];
                    final bool isUser = m['sender_type'] == 'user';

                    return Align(
                      alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                          isUser ? Colors.blueAccent : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['message'] ?? '',
                              style: TextStyle(
                                color:
                                isUser ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formatTime(m['created_at']),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isUser
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                if (isUser) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    m['read_by_admin'] == true
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: 16,
                                    color: m['read_by_admin'] == true
                                        ? Colors.yellow
                                        : Colors.brown,
                                  ),
                                ]
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /* -------- ADMIN TYPING -------- */
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('chat_typing')
                .stream(primaryKey: ['conversation_id'])
                .eq('conversation_id', activeConversationId!),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox.shrink();
              }

              final isAdminTyping =
                  snapshot.data!.first['is_admin_typing'] == true;

              return isAdminTyping
                  ? const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 6),
                child: Text(
                  "Support est en train d’écrire…",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              )
                  : const SizedBox.shrink();
            },
          ),

          /* -------- INPUT -------- */
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: _onUserTyping,
                    onSubmitted: (_) => sendMessage(),
                    decoration: const InputDecoration(
                      hintText: "Votre message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blueAccent,
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
