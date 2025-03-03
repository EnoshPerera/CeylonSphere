import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceChatbot extends StatefulWidget {
  @override
  _VoiceChatbotState createState() => _VoiceChatbotState();
}

class _VoiceChatbotState extends State<VoiceChatbot> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _text = "Press the button and start speaking...";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  // ✅ Fix: Corrected the TTS function
  void speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice Chatbot")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_text, style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => speak(_text),
            icon: Icon(Icons.volume_up),
            label: Text("Listen"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
