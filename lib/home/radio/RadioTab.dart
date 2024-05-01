import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/SettingsProvider.dart';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class RadioTab extends StatefulWidget {
  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  AudioPlayer audioPlayer = AudioPlayer();
  String audioUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchAudioUrl();
  }

  Future<void> _fetchAudioUrl() async {
    try {
      final response =
          await http.get(Uri.parse('https://data-rosy.vercel.app/radio.json'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          audioUrl = jsonData["radios"][14]['url'];
        });
      } else {
        throw Exception('Failed to load audio URL');
      }
    } catch (e) {
      print('Error fetching audio URL: $e');
    }
  }

  Future<void> _playAudio() async {
    if (audioUrl.isNotEmpty) {
      try {
        await audioPlayer.play(UrlSource(audioUrl));
      } catch (e) {}
    }
  }

  _stopAudio() async {
    await audioPlayer.stop();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  bool ok = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){


                
              },
                child: Image.asset("assets/images/radio_image.png")),
            SizedBox(
              height: 50,
            ),
            Text(
              " القرآن الكريم",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 30,
            ),
            //Image.asset(settingsProvider.getradio()),
            IconButton(
              onPressed: () {
                setState(() {
                  if (ok) {
                    ok = false;
                    _stopAudio();
                  } else {
                    ok = true;
                    _playAudio();
                  }
                });
              },
              icon: !ok
                  ? Icon(
                      Icons.play_arrow,
                      size: 38,
                    )
                  : Icon(
                      Icons.stop,
                      size: 38,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
