import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    "Google": HighlightedWord(
      onTap: () => print('Google'),
      textStyle: const TextStyle(
        color: Colors.orangeAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Facebook": HighlightedWord(
      onTap: () => print('Facebook'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    "YouTube": HighlightedWord(
      onTap: () => print('YouTube'),
      textStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    "call": HighlightedWord(
      onTap: () => print('call'),
      textStyle: const TextStyle(
        color: Colors.greenAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    "mail": HighlightedWord(
      onTap: () => print('mail'),
      textStyle: TextStyle(
        color: Colors.pinkAccent,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    "music": HighlightedWord(
      onTap: () => print('music'),
      textStyle: const TextStyle(
        color: Colors.teal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Ammu": HighlightedWord(
      onTap: () => print('ammu'),
      textStyle: const TextStyle(
        color: Colors.teal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    "Snapchat": HighlightedWord(
      onTap: () => print('Snapchat'),
      textStyle: const TextStyle(
        color: Colors.teal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "How can I help you now?";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  FlutterTts _tts = FlutterTts();

  _returnSpeak(String _title) async {
    await _tts.setLanguage("en-US");
    print(_tts.getLanguages);
    await _tts.setPitch(1);
    await _tts.setSpeechRate(1.2);
    print(await _tts.getVoices);
    await _tts.speak(_title);
  }

  String _assitanceSpeak = "My Assitant!";
//'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        title: Text("My AI Assistant"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.greenAccent,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _text == null ? "" : _text.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.greenAccent,
              height: 4,
              thickness: 3,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: TextHighlight(
                  text: _assitanceSpeak.length == null ? " " : _assitanceSpeak,
                  words: _highlights.length == null ? " " : _highlights,
                  textStyle: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            _openApp(val.recognizedWords);
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  _openApp(String _voiceTitle) {
    if (_voiceTitle == "open Google") {
      _returnSpeak("Opening Google");
      setState(() {
        _assitanceSpeak = "Opening Google";
      });
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        String url = "https://www.google.com/";
        _launchAssistanceApp(url);
      });
    } else if (_voiceTitle == "hey what's your name") {
      String _assTalk = "You haven't set my name yet. I wish I have a name!";
      setState(() {
        _assitanceSpeak = _assTalk;
      });
      _returnSpeak(_assTalk);
    } else if (_voiceTitle == "hey who are you") {
      String _assTalk =
          "I'm your AI assistant, based on some tricks. Made by Mohammad Saif!";
      setState(() {
        _assitanceSpeak = _assTalk;
      });
      _returnSpeak(_assTalk);
    } else if (_voiceTitle == "hey how are you") {
      String _returnWord = "I'm fine, thanks for asking. What about you?";
      _returnSpeak(_returnWord);
      setState(() {
        _assitanceSpeak = _returnWord;
      });
    } else if (_voiceTitle == "open Facebook") {
      _returnSpeak("Opening Facebook");
      setState(() {
        _assitanceSpeak = "Opening Facebook";
      });

      Future.delayed(Duration(milliseconds: 500)).then((value) {
        // String url = "https://www.facebook.com/";
        // _launchAssistanceApp(url);
        AppAvailability.launchApp("com.facebook.katana");
      });
    } else if (_voiceTitle == "open Snapchat") {
      _returnSpeak("Opening Snapchat");
      setState(() {
        _assitanceSpeak = "Opening Snapchat";
      });

      Future.delayed(Duration(milliseconds: 500)).then((value) {
        AppAvailability.launchApp("com.snapchat.android");
      });
    } else if (_voiceTitle == "open notes") {
      _returnSpeak("Opening notes");
      setState(() {
        _assitanceSpeak = "Opening notes";
      });

      Future.delayed(Duration(milliseconds: 500)).then((value) {
        AppAvailability.launchApp("com.samsung.android.app.notes");
      });
    } else if (_voiceTitle == "call my Ammu") {
      String _assTalk = "Great! calling your Mom.";
      setState(() {
        _assitanceSpeak = _assTalk;
      });
      _returnSpeak(_assTalk);
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        String url = "tel:01800000000";
        _makePhoneCall(url);
      });
    } else if (_voiceTitle == "send a mail") {
      String _assTalk = "Sending email";
      setState(() {
        _assitanceSpeak = _assTalk;
      });
      _returnSpeak(_assTalk);
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        _sendMail();
      });
    } else if (_voiceTitle == "open notes") {
      setState(() {
        _assitanceSpeak = "Opening notes";
      });
      _returnSpeak("Opening notes");
      print("Opening notes");
    } else if (_voiceTitle == "open music") {
      _returnSpeak("Opening music");
      setState(() {
        _assitanceSpeak = "Opening music";
      });

      Future.delayed(Duration(milliseconds: 500)).then((value) {
        AppAvailability.launchApp("com.google.android.music");
      });
    } else if (_voiceTitle == "open YouTube") {
      setState(() {
        _assitanceSpeak = "Opening YouTube";
      });
      _returnSpeak("Opening YouTube");
      String url = "https://www.youtube.com/";
      _launchAssistanceApp(url);
    } else if (_voiceTitle == "open map") {
      setState(() {
        _assitanceSpeak = "Opening Map";
      });
      _returnSpeak("Opening Map");
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        _openMap();
      });
    } else if (_voiceTitle == "send a message to my number") {
      setState(() {
        _assitanceSpeak = "Sending message";
      });

      _returnSpeak("Sending message");
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        _textMe();
      });
    }
    // else {
    //   String _assTalk =
    //       "Sorry, I didn't recognize your talking. Please, try to say again!";

    //   Future.delayed(Duration(seconds: 5)).then((value) {
    //     setState(() {
    //       _assitanceSpeak = _assTalk;
    //     });
    //     _returnSpeak(_assTalk);
    //   });
    // }
  }

  Future<void> _launchAssistanceApp(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _openMap() async {
    final String lat = "18.94020538352518";
    final String lng = "41.92540835913051";
    final String googleMapsUrl = "comgooglemaps://?center=$lat,$lng";
    final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lng";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    }
    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      throw "Couldn't launch URL";
    }
  }

  Future<void> _sendMail() async {
    final url = Uri.encodeFull(
        'mailto:rasoftsolution.help@gmail.com?subject=From my assistance&body=This is a test mail, send by my virtual assistance');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _textMe() async {
    const uri = 'sms:0180000000';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
