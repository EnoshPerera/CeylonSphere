import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'dart:io';
// Add these imports for speech recognition and text-to-speech
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voxa Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E5631), // Dark green as seed color
          primary: const Color(0xFF1E5631), // Dark green primary
          secondary: const Color(0xFF2E7D32), // Lighter green secondary
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true, // Center the title
          titleTextStyle: TextStyle(
            color: Color(0xFF1E5631),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ChatMessage> messages = [];
  bool _isLoading = false;
  bool _isTyping = false;
  String _currentTypingMessage = '';
  int _typingIndex = 0;
  final TextEditingController _textController = TextEditingController();

  // Add speech recognition and text-to-speech instances
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isSpeaking = false;

  final ChatUser currentUser = ChatUser(
    id: '0',
    firstName: 'User',
  );

  final ChatUser voxaUser = ChatUser(
    id: '1',
    firstName: 'Voxa',
    profileImage: 'https://avatars.githubusercontent.com/u/139895814',
  );

  @override
  void initState() {
    super.initState();
    // Initialize speech recognition and text-to-speech
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initSpeech();
    _initTts();
  }

  // Initialize speech recognition
  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() {
            _isListening = false;
          });
        }
      },
    );
  }

  // Initialize text-to-speech
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  // Start listening for speech input
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print("Speech recognition status: $status");
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (error) {
          print("Speech recognition error: $error");
          setState(() {
            _isListening = false;
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        try {
          _speech.listen(
            onResult: (result) {
              setState(() {
                _textController.text = result.recognizedWords;
                // If we have final results and words were recognized, send the message
                if (result.finalResult && result.recognizedWords.isNotEmpty) {
                  sendTextMessage(result.recognizedWords);
                }
              });
            },
            listenFor: const Duration(seconds: 30),
            pauseFor: const Duration(seconds: 5),
            partialResults: true,
            localeId: "en_US",
            cancelOnError: true,
            listenMode: stt.ListenMode.confirmation,
          );
        } catch (e) {
          print("Error listening: $e");
          setState(() {
            _isListening = false;
          });
        }
      } else {
        print("Speech recognition not available");
      }
    }
  }

  // Stop listening for speech input
  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  // Speak the text
  Future<void> _speak(String text) async {
    if (!_isSpeaking) {
      setState(() {
        _isSpeaking = true;
      });
      await _flutterTts.speak(text);
    }
  }

  // Stop speaking
  Future<void> _stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _speech.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: CupertinoPageScaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.back,
              color: Color(0xFF1E5631),
            ),
            onPressed: () {
              // Navigate back to the previous page
              Navigator.pop(context);
            },
          ),
          middle: const Text(
            'Voxa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF1E5631),
            ),
          ),
          backgroundColor: Colors.white,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xFFE5E5E5),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (_isLoading)
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFF1E5631),
                ),
              Expanded(
                child: buildUI(),
              ),
              buildModernInputBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor:
        const Color(0xFF1E5631), // Dark green for user messages
        containerColor: Colors.white,
        textColor: Colors.black87,
        showTime: true,
        borderRadius: 20,
        messagePadding: const EdgeInsets.all(12),
        messageTextBuilder: (message, previousMessage, nextMessage) {
          if (message.user.id == voxaUser.id) {
            // Using custom message builder for AI responses
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MarkdownBody(
                    data: formatMessageWithHeadings(message.text),
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      h2: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      h3: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      p: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      strong: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      listBullet: const TextStyle(
                        color: Colors.black87,
                      ),
                      code: const TextStyle(
                        backgroundColor: Color(0xFFF1F1F1),
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                // Add text-to-speech button for AI messages
                if (message.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_isSpeaking) {
                          _stopSpeaking();
                        } else {
                          _speak(message.text);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _isSpeaking
                              ? Colors.grey.shade300
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isSpeaking
                              ? CupertinoIcons.stop_fill
                              : CupertinoIcons.speaker_2_fill,
                          color: const Color(0xFF1E5631),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            // Normal text for user messages
            return Text(
              message.text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.white,
              ),
            );
          }
        },
      ),
      inputOptions: InputOptions(
        sendButtonBuilder: (_) => const SizedBox.shrink(),
        inputDecoration: const InputDecoration(
          hintText: "",
          border: InputBorder.none,
        ),
        alwaysShowSend: false,
        sendOnEnter: true,
        inputDisabled: true, // We're using our custom input
      ),
      messageListOptions: const MessageListOptions(
        showDateSeparator: true,
        dateSeparatorBuilder: null,
        chatFooterBuilder: null,
        loadEarlierBuilder: null,
      ),
    );
  }

  String formatMessageWithHeadings(String text) {
    // This function enhances plain text with markdown formatting
    // It identifies potential headings and formats them

    final lines = text.split('\n');
    final formattedLines = <String>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Check if this line looks like a heading (short, ends with colon, all caps, etc.)
      if (line.isNotEmpty &&
          (line.endsWith(':') ||
              (line.length < 60 && line == line.toUpperCase()) ||
              (i > 0 &&
                  i < lines.length - 1 &&
                  lines[i - 1].isEmpty &&
                  lines[i + 1].isEmpty))) {
        // Determine heading level based on characteristics
        if (line == line.toUpperCase() && line.length < 30) {
          formattedLines.add('# $line'); // H1 for all caps, short lines
        } else if (line.endsWith(':')) {
          formattedLines.add('## $line'); // H2 for lines ending with colon
        } else if (line.length < 50) {
          formattedLines.add('### $line'); // H3 for other potential headings
        } else {
          formattedLines.add(line); // Not a heading
        }
      } else {
        formattedLines.add(line);
      }
    }

    return formattedLines.join('\n');
  }

  Widget buildModernInputBox() {
    // Wrap with Material for TextField compatibility
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Image picker button
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.photo,
                color: _isTyping
                    ? CupertinoColors.systemGrey4
                    : const Color(0xFF1E5631),
                size: 28,
              ),
              onPressed: _isTyping ? null : sendMediaMessage,
            ),
            // Voice input button
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                _isListening ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
                color: _isListening
                    ? CupertinoColors.systemRed
                    : (_isTyping
                    ? CupertinoColors.systemGrey4
                    : const Color(0xFF1E5631)),
                size: 28,
              ),
              onPressed: _isTyping
                  ? null
                  : () {
                if (_isListening) {
                  _stopListening();
                } else {
                  _startListening();
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F8),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                // Use TextField instead of CupertinoTextField for better Material compatibility
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: _isListening
                        ? 'Listening...'
                        : (_isTyping
                        ? 'Voxa is responding...'
                        : 'Message Voxa...'),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: _isListening
                          ? CupertinoColors.systemRed
                          : (_isTyping
                          ? Colors.grey.shade400
                          : Colors.grey.shade600),
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  enabled: !_isTyping,
                  onSubmitted: (text) {
                    if (!_isTyping && text.trim().isNotEmpty) {
                      sendTextMessage(text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Dynamic button that changes between SEND and STOP
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                _isTyping ? CupertinoColors.black : const Color(0xFF1E5631),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  _isTyping
                      ? CupertinoIcons.stop_fill
                      : CupertinoIcons.arrow_up,
                  color: CupertinoColors.white,
                  size: 20,
                ),
                onPressed: () {
                  if (_isTyping) {
                    stopTypingEffect();
                  } else if (_textController.text.trim().isNotEmpty) {
                    sendTextMessage(_textController.text);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendTextMessage(String text) {
    bool fromVoice = _isListening;
    sendMessage(
        ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: text,
        ),
        fromVoice: fromVoice);
    _textController.clear();
  }

  Future<String> sendGeminiRequest(String prompt) async {
    const apiKey =
        'AIzaSyAebUebsP1MT5bro2qSfO-DbA6CCCmWmng'; // Replace with your actual API key
    const model = 'gemini-2.0-flash';
    const apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';

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

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to load response: ${response.statusCode}');
    }
  }

  void sendMessage(ChatMessage chatMessage, {bool fromVoice = false}) async {
    // Stop any ongoing speech when sending a new message
    if (_isSpeaking) {
      await _stopSpeaking();
    }

    setState(() {
      messages.insert(0, chatMessage);
      _isLoading = true;
    });

    try {
      final prompt = chatMessage.text;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        // Handle image-based query
        // Note: This implementation doesn't actually send the image to Gemini
        // You'll need to implement multimodal API calls for image processing
        final response =
        await sendGeminiRequest("Describing an image: $prompt");
        simulateTypingEffect(response, speakResponse: fromVoice);
      } else {
        // Handle text-only query
        final response = await sendGeminiRequest(prompt);
        simulateTypingEffect(response, speakResponse: fromVoice);
      }
    } catch (error, stackTrace) {
      // Log the full error and stack trace
      print('Error: $error');
      print('Stack Trace: $stackTrace');

      String errorMessage =
          "# Error\n\nI encountered a problem. Please try again.";

      // Handle specific API key errors
      if (error.toString().contains("404")) {
        errorMessage =
        "# Error\n\nThe model or API version is not found. Please check the model name and API version.";
      } else if (error.toString().contains("401") ||
          error.toString().contains("Unauthorized")) {
        errorMessage =
        "# Error\n\nInvalid API key. Please check your API key and try again.";
      } else if (error.toString().contains("SocketException") ||
          error.toString().contains("Network is unreachable")) {
        errorMessage =
        "# Error\n\nNo internet connection. Please check your network and try again.";
      }

      addVoxaMessage(errorMessage, speakResponse: fromVoice);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void simulateTypingEffect(String response, {bool speakResponse = false}) {
    setState(() {
      _isTyping = true;
      _currentTypingMessage = '';
      _typingIndex = 0;
    });

    final typingMessage = ChatMessage(
      user: voxaUser,
      createdAt: DateTime.now(),
      text: '', // Start with an empty message
    );

    setState(() {
      messages.insert(0, typingMessage);
    });

    const delay = Duration(milliseconds: 30); // Faster typing for better UX

    void addNextCharacter() {
      if (_typingIndex < response.length && _isTyping) {
        setState(() {
          _currentTypingMessage += response[_typingIndex];
          typingMessage.text = _currentTypingMessage;
        });
        _typingIndex++;
        Future.delayed(
            delay, addNextCharacter); // Add the next character after a delay
      } else {
        setState(() {
          _isTyping = false; // Stop typing effect

          // Speak the response if it came from voice input
          if (speakResponse) {
            _speak(response);
          }
        });
      }
    }

    addNextCharacter(); // Start the typing effect
  }

  void stopTypingEffect() {
    if (_isTyping) {
      setState(() {
        _isTyping = false;

        // Add a message indicating the response was stopped
        if (messages.isNotEmpty) {
          messages[0].text += "\n\n*Response stopped by user*";
        }
      });

      // Show a snackbar to confirm the action
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Response stopped'),
          duration: Duration(seconds: 1),
          backgroundColor: CupertinoColors.black,
        ),
      );
    }
  }

  void addVoxaMessage(String text, {bool speakResponse = false}) {
    setState(() {
      messages.insert(
          0,
          ChatMessage(
            user: voxaUser,
            createdAt: DateTime.now(),
            text: text,
          ));

      // Speak the response if it came from voice input
      if (speakResponse) {
        _speak(text);
      }
    });
  }

  Future<void> sendMediaMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: 'Describe this image',
        medias: [
          ChatMedia(
            url: file.path,
            fileName: file.name,
            type: MediaType.image,
          ),
        ],
      );

      sendMessage(chatMessage);
    }
  }
}