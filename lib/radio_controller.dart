import 'package:audioplayers/audioplayers.dart';

class RadioController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String radioUrl = "https://a4.asurahosting.com:6990/radio.mp3";

  playRadio() {
    _audioPlayer.play(radioUrl);
  }

  stopRadio() {
    _audioPlayer.stop();
  }
}
