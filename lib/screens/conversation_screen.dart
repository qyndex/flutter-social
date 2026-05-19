import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_provider.dart';
import '../models/social_models.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final String conversationId;
  const ConversationScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _messages.addAll([
      Message(id: 'm1', senderId: 'u1', content: 'Hey! How are you?',
          sentAt: now.subtract(const Duration(hours: 2)), isRead: true),
      Message(id: 'm2', senderId: 'me', content: "I'm good, thanks! Working on a Flutter project.",
          sentAt: now.subtract(const Duration(hours: 1, minutes: 55)), isRead: true),
      Message(id: 'm3', senderId: 'u1', content: 'Nice! Flutter is amazing.',
          sentAt: now.subtract(const Duration(minutes: 10)), isRead: false),
    ]);
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(
        id: 'm${_messages.length + 1}',
        senderId: 'me',
        content: text,
        sentAt: DateTime.now(),
        isRead: false,
      ));
    });
    _ctrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(conversationsProvider);
    final conv = conversations.firstWhere((c) => c.id == widget.conversationId,
        orElse: () => conversations.first);

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(conv.participant.avatarUrl),
          ),
          const SizedBox(width: 8),
          Text(conv.participant.fullName.isNotEmpty ? conv.participant.fullName : conv.participant.username),
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.senderId == 'me';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(msg.content,
                        style: TextStyle(
                          color: isMe
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        )),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16, right: 8, top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _send,
                color: Theme.of(context).colorScheme.primary,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
