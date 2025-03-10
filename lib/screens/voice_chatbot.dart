import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isSpeaking = false;
  final List<ChatMessage> messages = [];
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();

  final ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'User',
  );

  final ChatUser botUser = ChatUser(
    id: '1',
    firstName: 'CeylonSphere',
  );

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initSpeech();
    _initTts();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CeylonSphere Chat',
            style: TextStyle(color: Color(0xFF1E5631))),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: currentUser,
              messages: messages,
              onSend: (ChatMessage m) => handleSubmitted(m.text),
              messageOptions: const MessageOptions(
                showTime: true,
                containerColor: Color(0xFF1E5631),
                textColor: Colors.white,
              ),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic,
                color: const Color(0xFF1E5631)),
            onPressed: _toggleListening,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: handleSubmitted,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF1E5631)),
            onPressed: () => handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  void _toggleListening() async {
    if (!_isListening) {
      var available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
              if (result.finalResult) {
                handleSubmitted(_textController.text);
                _isListening = false;
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.insert(
        0,
        ChatMessage(
          text: text,
          user: currentUser,
          createdAt: DateTime.now(),
        ),
      );
      _textController.clear();
      _isLoading = true;
    });

    // Add your chatbot response logic here
    // For now, let's echo the message
    String response = "You said: $text";

    setState(() {
      messages.insert(
        0,
        ChatMessage(
          text: response,
          user: botUser,
          createdAt: DateTime.now(),
        ),
      );
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _speech.cancel();
    _flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }
}
