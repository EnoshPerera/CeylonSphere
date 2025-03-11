import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class TravelChatbotScreen extends StatefulWidget {
  const TravelChatbotScreen({super.key});

  @override
  State<TravelChatbotScreen> createState() => _TravelChatbotScreenState();
}

class _TravelChatbotScreenState extends State<TravelChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final String _apiKey = ApiConfig.openAiApiKey;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text:
          'Hello! I\'m your Sri Lanka travel assistant. Ask me anything about destinations, culture, transportation, or travel tips in Sri Lanka!',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
      ));
      _isLoading = true;
    });

    _messageController.clear();

    try {
      print('Sending request to API...');
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a knowledgeable travel assistant specializing in Sri Lanka tourism. Provide helpful, accurate, and concise information about destinations, culture, customs, transportation, and travel tips in Sri Lanka.',
            },
            {
              'role': 'user',
              'content': message,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['choices'][0]['message']['content'];
        setState(() {
          _messages.add(ChatMessage(
            text: botResponse,
            isUser: false,
          ));
          _isLoading = false;
        });
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _messages.add(ChatMessage(
            text:
                'Error: ${errorData['error']['message'] ?? 'Unknown error occurred'}',
            isUser: false,
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error during API call: $e');
      setState(() {
        _messages.add(ChatMessage(
          text:
              'Sorry, I encountered an error: ${e.toString()}. Please try again.',
          isUser: false,
        ));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Travel Assistant'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    message: message.text,
                    isUser: message.isUser,
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _messageController,
                      placeholder: 'Ask anything about Sri Lanka...',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.arrow_up_circle_fill),
                    onPressed: () {
                      _sendMessage(_messageController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: CupertinoColors.activeGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.person,
                color: CupertinoColors.white,
                size: 16,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser ? CupertinoColors.white : CupertinoColors.black,
                ),
              ),
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: CupertinoColors.activeBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.person,
                color: CupertinoColors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}
