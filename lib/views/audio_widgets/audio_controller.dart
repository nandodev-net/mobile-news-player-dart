import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duration/duration.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:noticias_sin_filtro/entities/audio.dart';

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

  initAudio(Audio audio_) {
    // pauseAudio();
    // sleep(Duration(milliseconds: 5));
    var audioUrl = audio_.audioUrl;
    var audioDuration = parseTime(audio_.duration+'.00');
    requestAudio(audioUrl, audioDuration);
    
  }

  requestAudio(String audioUrl, Duration audioDuration) {
      //var response = http.get(Uri.parse(audioUrl));
      //final mp3 = MP3Processor.fromBytes(response);

      audioPlayer.play(UrlSource(audioUrl));
      audioPlayer.setVolume(100);
      totalAudioDuration = audioDuration;

    audioPlayer.onPositionChanged.listen((updatedPosition) {
      currentAudioPosition = updatedPosition;
      if (updatedPosition != null && currentAudioPosition != null) {
        setSliderPosition(audioDuration, currentAudioPosition);
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