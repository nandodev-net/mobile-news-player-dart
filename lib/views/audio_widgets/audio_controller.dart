import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    audioPlayer.setSourceUrl(audioUrl);
    audioPlayer.resume();
      audioPlayer.onDurationChanged.listen((updatedDuration) {
      totalAudioDuration = updatedDuration;
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