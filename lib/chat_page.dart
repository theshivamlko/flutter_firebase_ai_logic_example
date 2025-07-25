import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'chat_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ValueNotifier<List<ChatModel>> chatMessages = ValueNotifier<List<ChatModel>>(
    [],
  );
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  TextEditingController textEditingController = TextEditingController();


  static final GenerationConfig generationConfig = GenerationConfig(
    // temperature: 100,
    // maxOutputTokens: 200,
    // responseMimeType:
  );

  static final String modalName = 'gemini-2.0-flash';

  static final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: modalName,
    // generationConfig: generationConfig,
    // tools: [],
    // systemInstruction:Content.system("You are a helpful AI assistant.
    // Respond to user queries in a friendly and informative manner."),
  );

  late ChatSession chatSession;

  @override
  void initState() {
    super.initState();
    chatSession = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), 
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          "Chat with AI",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, isLoadingValue, child) {
          return ValueListenableBuilder(
            valueListenable: chatMessages,
            builder: (context, messages, child) {
              return Column(
                children: [
                  // Chat messages area
                  Expanded(
                    child: messages.isEmpty
                        ? _buildWelcomeScreen()
                        : _buildChatList(messages, isLoadingValue),
                  ),
                  // Input area
                  _buildInputArea(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Start Chatting",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Have a conversation with AI",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          ),
          const SizedBox(height: 48),
          _buildSuggestionCards(),
        ],
      ),
    );
  }

  Widget _buildSuggestionCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSuggestionCard(
                "Tell me a joke",
                Icons.mood_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSuggestionCard(
                "Explain quantum physics",
                Icons.science_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSuggestionCard(
                "Plan my day",
                Icons.schedule_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSuggestionCard(
                "Creative writing tips",
                Icons.lightbulb_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        textEditingController.text = text;
        submitText(text);
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade700, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.green.shade400, size: 24),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(List<ChatModel> messages, bool isLoadingValue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length + (isLoadingValue ? 1 : 0),
        itemBuilder: (context, index) {
          if (isLoadingValue && index == 0) {
            return _buildLoadingMessage();
          }

          final messageIndex = isLoadingValue ? index - 1 : index;
          final message = messages[messageIndex];

          return _buildChatBubble(message);
        },
      ),
    );
  }

  Widget _buildChatBubble(ChatModel message) {
    final isUser = message.type != "modal";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.blue.shade400],
                ),
              ),
              child: const Icon(Icons.smart_toy, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? Colors.green.shade600 : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
                border: !isUser
                    ? Border.all(color: Colors.grey.shade700, width: 1)
                    : null,
              ),
              child: Text(
                message.body,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade600,
              ),
              child: const Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.blue.shade400],
              ),
            ),
            child: const Icon(Icons.smart_toy, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade700, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Thinking...",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Colors.grey.shade800, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade700, width: 1),
                ),
                child: TextField(
                  controller: textEditingController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      submitText(value);
                    }
                  },
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.blue.shade400],
                ),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    if (textEditingController.text.trim().isNotEmpty) {
                      submitText(textEditingController.text);
                    }
                  },
                  child: const Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitText(String text) async {
    if (text.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    textEditingController.clear();
    sendMessageToChat(text);
  }

  void sendMessageToChat(String text) async {
    try {
      isLoading.value = true;
      print("sendMessageToChat text $text");
      chatMessages.value = [ChatModel.fromUser(text), ...chatMessages.value];

      final message = Content.text(text);

      final GenerateContentResponse generateContentResponse = await chatSession
          .sendMessage(message);

      print("sendMessageToChat response ${generateContentResponse.text}");
      chatMessages.value = [
        ChatModel.fromModal(generateContentResponse.text ?? "N/A"),
        ...chatMessages.value,
      ];
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      chatMessages.value = [
        ChatModel.fromModal(e.toString()),
        ...chatMessages.value,
      ];
      print("Error sendMessageToChat: $e");
    }
  }
}
