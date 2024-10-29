enum ScreenType {
  car('Car screen'),
  laptop('Laptop'),
  monitor('Monitor'),
  phone('Phone'),
  plane('Plane screen'),
  projector('Projector'),
  tv('TV'),
  other('Other');

  const ScreenType(this.label);
  final String label;
}

enum Platform{
  apple('Apple TV+'),
  bluray('Blu-ray'),
  cinema('Cinema'),
  digital('Digital copy'),
  disney('Disney+'),
  dvd('DVD'),
  google('Google Play'),
  hbo('HBO'),
  joyn('Joyn'),
  movistar('Movistar'),
  netflix('Netflix'),
  primeVideo('Prime Video'),
  youtube('YouTube'),
  torrent('Torrent'),
  tv('TV'),
  other('Other');

  const Platform(this.label);
  final String label;
}

enum MovieLanguage {
  english('English'),
  arabic('Arabic'),
  french('French'),
  german('German'),
  italian('Italian'),
  japanese('Japanese'),
  korean('Korean'),
  mandarin('Mandarin'),
  polish('Polish'),
  portuguese('Portuguese'),
  spanish('Spanish'),
  other('Other');

  const MovieLanguage(this.label);
  final String label;
}

enum Location {
  home('Home'),
  cinema('Cinema'),
  car('Car'),
  family('Family\'s'),
  friend('Friend\'s'),
  hotel('Hotel'),
  plane('Plane'),
  school('School'),
  other('Other');

  const Location(this.label);
  final String label;
}

Platform? stringToPlatform (String? videoSource){
  switch (videoSource){
    case 'cinema':
      return Platform.cinema;
    case 'digital':
      return Platform.digital;
    case 'streaming':
      return Platform.torrent;
    case 'streaming/amazon_video':
      return Platform.primeVideo;
    case 'streaming/disney_plus':
      return Platform.disney;
    case 'streaming/google_play':
      return Platform.google;
    case 'streaming/hbo':
      return Platform.hbo;
    case 'streaming/hbo_max':
      return Platform.hbo;
    case 'streaming/movistar':
      return Platform.movistar;
    case 'streaming/netflix':
      return Platform.netflix;
    case 'streaming/youtube':
      return Platform.youtube;
    case 'tv':
      return Platform.tv;
    default:
      return null;
  }
}

ScreenType? stringToScreenType (String? screentype){
  switch (screentype){
    case 'laptop_monitor':
      return ScreenType.laptop;
    case 'phone':
      return ScreenType.phone;
    case 'projector':
      return ScreenType.projector;
    case 'tv':
      return ScreenType.tv;
    case 'other':
      return ScreenType.other;
    default:
      return null;
  }
}

MovieLanguage? stringToMovieLanguage (String? movieLanguage){
  switch (movieLanguage){
    case 'eng':
      return MovieLanguage.english;
    case 'eng-US':
      return MovieLanguage.english;
    case 'spa':
      return MovieLanguage.spanish;
    case 'spa-MX':
      return MovieLanguage.spanish;
    case 'deu':
      return MovieLanguage.german;
    case 'fra':
      return MovieLanguage.french;
    case 'ita':
      return MovieLanguage.italian;
    case 'jpn':
      return MovieLanguage.japanese;
    case 'kor':
      return MovieLanguage.korean;
    case 'por':
      return MovieLanguage.portuguese;
    case 'zho':
      return MovieLanguage.mandarin;
    default:
      return null;
  }
}