import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
final String requestId;
final String senderId;
final String senderType;

const ChatPage({
Key? key,
required this.requestId,
required this.senderId,
required this.senderType,
}) : super(key: key);
// ... rest of the file

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF6B7B8A);
  static const Color borderColor = Color(0xFFE0E0E0);

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    try {
      final batch = FirebaseFirestore.instance.batch();
      final msgRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.requestId)
          .collection('messages')
          .doc();
      final requestRef = FirebaseFirestore.instance
          .collection('consultant_requests')
          .doc(widget.requestId);

      batch.set(msgRef, {
        'senderId': widget.senderId,
        'senderType': widget.senderType,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      batch.update(requestRef, {
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      debugPrint("Send Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Consultation Chat', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryTeal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.requestId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text("Error loading messages"));
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: primaryTeal));

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data = messages[index].data() as Map<String, dynamic>;
                      final bool isMe = data['senderId'] == widget.senderId;
                      final bool isSystem = data['senderType'] == 'system';

                      if (isSystem) return _buildSystemMessage(data['text'] ?? '');
                      return _buildMessageBubble(data, isMe);
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> data, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(data['senderType']),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? primaryTeal : pureWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: Text(
                data['text'] ?? '',
                style: TextStyle(color: isMe ? Colors.white : textPrimary, fontSize: 15),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe) _buildAvatar(widget.senderType),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(String text) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
        child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: pureWhite,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type here...',
                filled: true,
                fillColor: smokeWhite,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: primaryTeal),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String type) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: type == 'admin' ? lightTeal : Colors.grey[400],
      child: Icon(type == 'admin' ? Icons.support_agent : Icons.person, color: Colors.white, size: 14),
    );
  }
}