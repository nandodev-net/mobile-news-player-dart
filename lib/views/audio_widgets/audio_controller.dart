import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp3_info/mp3_info.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AudioController extends ChangeNotifier {
  Duration? totalAudioDuration;
  Duration? currentAudioPosition;
  double currentSliderPosition = 0.0;
  String playerAudioState = '';

  // AudioController() {
  //   playAudio();
  // }

  AudioPlayer audioPlayer = AudioPlayer();

  setSliderPosition(Duration? total, Duration? partial) {
    if ((total != null) && (partial != null)) {
      currentSliderPosition = partial.inMilliseconds / total.inMilliseconds;
    }
  }

  initAudio(String audioUrl) {
    // pauseAudio();
    // sleep(Duration(milliseconds: 5));
    requestAudio(audioUrl);
    
  }

  requestAudio(String audioUrl) {
      //var response = http.get(Uri.parse(audioUrl));
      //final mp3 = MP3Processor.fromBytes(response);

      audioPlayer.play(UrlSource(audioUrl));
      const fastestMarathon = Duration(seconds: 12);
      audioPlayer.setVolume(1);
      audioPlayer.onPositionChanged.listen((Duration d) {
        print('CHAU '+d.toString());
        totalAudioDuration = fastestMarathon;
        notifyListeners();
      });

    audioPlayer.onPositionChanged.listen((updatedPosition) {
      currentAudioPosition = updatedPosition;
      if (updatedPosition != null && currentAudioPosition != null) {
        setSliderPosition(totalAudioDuration, currentAudioPosition);
      }
      notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing)playerAudioState='PLAY';
      if (event == PlayerState.stopped)playerAudioState='STOP';
      if (event == PlayerState.paused)playerAudioState='PAUSE';
      notifyListeners();
    });
  }

  pauseAudio() {
    audioPlayer.pause();
  }

  playAudio() {
    audioPlayer.resume();
  }

  stopAudio() {
    audioPlayer.stop();
  }

  exitAudio() {
    audioPlayer.dispose();
  }

  seekAudio(Duration durationToSeek){
    audioPlayer.seek(durationToSeek);
  }
}

final audioProvider = ChangeNotifierProvider<AudioController>((ref) {
  return AudioController();
});