import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import '../config/keys.dart';

Future<String> sendGeminiRequest(String prompt) async {
  const apiKey = 'AIzaSyAebUebsP1MT5bro2qSfO-DbA6CCCmWmng'; // Replace with your actual API key
  const model = 'gemini-2.0-flash';
  const apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';

  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'contents': [
      {
        'role': 'user',
        'parts': [
          {'text': prompt},
        ],
      },
    ],
    'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 8192,
      },
  });

  try {
    print('Sending request to Gemini API...'); // Debug print
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    print('Response status code: ${response.statusCode}'); // Debug print
    print('Response body: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e, stackTrace) {
    print('Error details: $e'); // Debug print
    print('Stack trace: $stackTrace'); // Debug print
    return "Error: Unable to get response from AI. Please try again.";
  }
}

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

  Future<void> _speak(String text) async {
    if (!_isSpeaking) {
      setState(() => _isSpeaking = true);
      await _flutterTts.speak(text);
    }
  }

  Future<void> _stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    }
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
              onSend: (ChatMessage message) {
                handleSubmitted(message
                    .text); // Wrap handleSubmitted to match expected type
              },
              messageOptions: const MessageOptions(
                showTime: true,
                containerColor: Color(0xFF1E5631),
                textColor: Colors.white,
              ),
              inputOptions: const InputOptions(
                sendOnEnter: false,
                inputDisabled: true,
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
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
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
                border: InputBorder.none,
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
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speech.initialize();
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
    }
  }

  Future<void> handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
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

    try {
      // Get response from Gemini API
      final response = await sendGeminiRequest(text);

      setState(() {
        messages.insert(
          0,
          ChatMessage(
            text: response,
            user: botUser,
            createdAt: DateTime.now(),
          ),
        );

        // Optionally speak the response if it came from voice input
        if (_isListening) {
          _flutterTts.speak(response);
        }
      });
    } catch (e) {
      print('Error: $e'); // For debugging
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            text: "I encountered an error. Please try again.",
            user: botUser,
            createdAt: DateTime.now(),
          ),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    _flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }
}
