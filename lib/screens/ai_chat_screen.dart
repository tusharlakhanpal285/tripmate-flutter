import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
// AI icon by Icons8 (https://icons8.com/icons)

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {

  final TextEditingController controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  Future<void> askAI() async {
    if (controller.text.trim().isEmpty) return;

    final userMessage = controller.text.trim();

    setState(() {
      messages.add({"role": "user", "text": userMessage});
      controller.clear();
      isLoading = true;
    });

    final response =
    await GeminiService().generateResponse(userMessage);

    setState(() {
      messages.add({
        "role": "ai",
        "text": response ?? "No response"
      });
      isLoading = false;
    });
  }

  Widget buildMessageBubble(Map<String, String> message) {
    final isUser = message["role"] == "user";

    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFF1E88E5)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          message["text"] ?? "",
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text(
          "Travel AI Assistant",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),

      body: Column(
        children: [

          /// CHAT AREA
          Expanded(
            child: messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// 🔥 Premium AI Circle
                  /// 🔥 Premium AI Logo with Glow
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E88E5).withOpacity(0.25),
                          blurRadius: 30,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assests/images/ai_icon.png",
                      height: 60,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Hi, how may I help you?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Ask me anything about your trip ✈️",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessageBubble(messages[index]);
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: CircularProgressIndicator(),
            ),

          /// INPUT AREA
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                )
              ],
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Ask about your trip...",
                      filled: true,
                      fillColor: const Color(0xFFF4F8FB),
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                  const Color(0xFF1E88E5),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: askAI,
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