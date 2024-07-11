class Images {
  String get background => 'background.png';
  String get ground => 'ground.png';
  String get bird1 => 'bird_1.png';
  String get pipe => 'pipe.png';
  String get pipeRotated => 'pipe_rotated.png';
  String get message => 'assets/images/message.png';
  String get gameOver => 'assets/images/gameover.png';
}

class Audio {
  String get background => 'background.mp3';
  String get birdDie => 'bird_die.mp3';
  String get birdPoint => 'bird_point.mp3';
  String get birdHit => 'bird_hit.mp3';
}

class Assets {
  Assets._();

  static final images = Images();
  static final audios = Audio();
}
