import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'openai_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final GeminiService geminiService = GeminiService();
  List<ChatMessage> messages = [];
  bool isLoading = false;

  static const Color primaryTeal = Color(0xFF008080);
  static const Color lightTeal = Color(0xFF20B2AA);
  static const Color smokeWhite = Color(0xFFF5F5F5);
  static const Color pureWhite = Color(0xFFFFFFFF);

  void sendMessage() async {
    if (controller.text.isEmpty) return;
    final userText = controller.text;
    setState(() {
      messages.add(ChatMessage(message: userText, isUser: true));
      isLoading = true;
    });
    controller.clear();
    final botReply = await geminiService.getReply(userText);
    setState(() {
      messages.add(ChatMessage(message: botReply, isUser: false));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: smokeWhite,
      appBar: AppBar(
        title: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: pureWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.chat, color: Colors.white, size: 18)),
          const SizedBox(width: 8), const Text("AI Consultancy", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
        backgroundColor: primaryTeal,
        elevation: 0,
      ),
      body: Column(children: [
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Align(
              alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: msg.isUser ? primaryTeal : pureWhite,
                  borderRadius: BorderRadius.circular(16).copyWith(
                    bottomRight: msg.isUser ? const Radius.circular(4) : null,
                    bottomLeft: !msg.isUser ? const Radius.circular(4) : null,
                  ),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)],
                ),
                child: Text(msg.message, style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87, fontSize: 14)),
              ),
            );
          },
        )),
        if (isLoading) Padding(padding: const EdgeInsets.all(8), child: Row(children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: primaryTeal, shape: BoxShape.circle)),
          const SizedBox(width: 4), Container(width: 8, height: 8, decoration: BoxDecoration(color: primaryTeal, shape: BoxShape.circle)),
          const SizedBox(width: 4), Container(width: 8, height: 8, decoration: BoxDecoration(color: primaryTeal, shape: BoxShape.circle)),
          const SizedBox(width: 8), const Text("Bot is typing...", style: TextStyle(color: Colors.grey)),
        ])),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: pureWhite, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)]),
          child: Row(children: [
            Expanded(child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Ask something...",
                border: InputBorder.none,
                filled: true,
                fillColor: smokeWhite,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: primaryTeal)),
              ),
              onSubmitted: (_) => sendMessage(),
            )),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(color: primaryTeal, shape: BoxShape.circle),
              child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: sendMessage),
            ),
          ]),
        ),
      ]),
    );
  }
}