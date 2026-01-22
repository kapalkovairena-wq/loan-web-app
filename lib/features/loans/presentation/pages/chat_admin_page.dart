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
  Timer? _refreshTimer;

  String? selectedConversationId;
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool _isUserAtBottom = true;

  @override
  void initState() {
    super.initState();
    loadLastConversation();
    _startAutoRefresh();
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      // reverse: true → le bas = position 0
      _isUserAtBottom = scrollController.offset <= 50;
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Future<void> sendAdminMessage() async {
    if (selectedConversationId == null) return;
    if (controller.text.trim().isEmpty) return;

    await supabase.from('chat_messages').insert({
      'conversation_id': selectedConversationId!,
      'sender_type': 'admin',
      'sender_firebase_uid': null,
      'message': controller.text.trim(),
    });

    await supabase.from('chat_typing').upsert({
      'conversation_id': selectedConversationId,
      'is_admin_typing': true,
    });

    await supabase.from('chat_typing').upsert({
      'conversation_id': selectedConversationId,
      'is_admin_typing': false,
    });


    controller.clear();

    // ⬇️ Scroll vers le dernier message (bas du chat)
    await Future.delayed(const Duration(milliseconds: 100));

    if (scrollController.hasClients) {
      scrollController.animateTo(
        0, // IMPORTANT car ListView reverse: true
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    // Scroll automatique vers le bas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  Future<void> loadLastConversation() async {
    final res = await supabase
        .from('chat_conversations')
        .select('id')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (res != null) {
      setState(() {
        selectedConversationId = res['id'];
      });
    }
  }

  String formatTime(String isoDate) {
    final date = DateTime.parse(isoDate).toLocal();
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin – Chats"),
      ),
      body: Row(
        children: [
          // ================= CONVERSATIONS =================
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

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_isUserAtBottom && scrollController.hasClients) {
                    scrollController.jumpTo(0);
                  }
                });

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conv = conversations[index];
                    final bool isSelected =
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

          // ================= MESSAGES =================
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
                        .eq('conversation_id', selectedConversationId!)
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
                          final bool isAdmin =
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
                                crossAxisAlignment:
                                isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                                      color: isAdmin ? Colors.white : Colors.black,
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

                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: supabase
                      .from('chat_typing')
                      .stream(primaryKey: ['conversation_id'])
                      .eq('conversation_id', selectedConversationId!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final typing = snapshot.data!.first['is_admin_typing'] == true;

                    return typing
                        ? const Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 6),
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

                // ================= INPUT =================
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border:
                    Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Réponse admin...",
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => sendAdminMessage(),
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
