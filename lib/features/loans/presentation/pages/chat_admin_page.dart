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
  Timer? _refreshTimer;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
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

  /* ---------------- READ BY ADMIN ---------------- */

  Future<void> markMessagesReadByAdmin() async {
    if (selectedConversationId == null) return;

    await supabase
        .from('chat_messages')
        .update({
      'read_by_admin': true,
      'read_at': DateTime.now().toIso8601String(),
    })
        .eq('conversation_id', selectedConversationId!)
        .eq('sender_type', 'user')
        .eq('read_by_admin', false);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Admin – Chats"),
            leading: isMobile && selectedConversationId != null
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() => selectedConversationId = null);
              },
            )
                : null,
          ),
          body: isMobile
              ? _buildMobileLayout()
              : _buildDesktopLayout(),
        );
      },
    );
  }

  /* ---------------- DESKTOP ---------------- */

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(width: 320, child: _buildConversations()),
        Expanded(child: _buildChat()),
      ],
    );
  }

  /* ---------------- MOBILE ---------------- */

  Widget _buildMobileLayout() {
    return selectedConversationId == null
        ? _buildConversations()
        : _buildChat();
  }

  /* ---------------- CONVERSATIONS ---------------- */

  Widget _buildConversations() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('admin_conversations_view')
          .stream(primaryKey: ['conversation_id'])
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
            final isSelected = selectedConversationId == conv['id'];
            final displayName = conv['receiver_full_name'] != ''
                ? conv['receiver_full_name']
                : conv['email'];

            return ListTile(
              selected: isSelected,
              title: Row(
                children: [
                  if (conv['unread_by_admin'] > 0)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                conv['email'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: conv['unread_by_admin'] > 0
                  ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  conv['unread_by_admin'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : null,
              onTap: () async {
                setState(() {
                  selectedConversationId = conv['conversation_id'];
                });

                await supabase
                    .from('chat_conversations')
                    .update({'unread_by_admin': 0})
                    .eq('id', conv['conversation_id']);

                await markMessagesReadByAdmin();
              },
            );
          },
        );
      },
    );
  }

  /* ---------------- CHAT ---------------- */

  Widget _buildChat() {
    if (selectedConversationId == null) {
      return const Center(
        child: Text("Sélectionnez une discussion"),
      );
    }

    return Column(
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
              if (messages.isNotEmpty &&
                  messages.first['sender_type'] == 'user') {
                markMessagesReadByAdmin();
              }

              return ListView.builder(
                reverse: true,
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final m = messages[index];
                  final isAdmin = m['sender_type'] == 'admin';

                  return Align(
                    alignment:
                    isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? Colors.green
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: isAdmin
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            m['message'],
                            enableInteractiveSelection: true,
                            showCursor: false,
                            cursorWidth: 1,
                            style: TextStyle(
                              color: isAdmin
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatTime(m['created_at']),
                                style: const TextStyle(fontSize: 11),
                              ),
                              if (isAdmin) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  m['read_by_user'] == true
                                      ? Icons.done_all
                                      : Icons.done,
                                  size: 16,
                                  color: m['read_by_user'] == true
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
        _buildTypingIndicator(),
        _buildInput(),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('chat_typing')
          .stream(primaryKey: ['conversation_id'])
          .eq('conversation_id', selectedConversationId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final isUserTyping =
            snapshot.data!.first['is_user_typing'] == true;

        return isUserTyping
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
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 140, // ← hauteur max du champ
              ),
              child: Scrollbar(
                thumbVisibility: true, // visible sur desktop
                child: TextField(
                  controller: controller,
                  enableInteractiveSelection: true,
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  scrollPhysics: const BouncingScrollPhysics(),
                  onChanged: _onAdminTyping,
                  decoration: const InputDecoration(
                    hintText: "Réponse support...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
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
    );
  }
}
