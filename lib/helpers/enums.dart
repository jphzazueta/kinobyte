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
  family('Familys'),
  friend('Friends'),
  hotel('Hotel'),
  plane('Plane'),
  school('School'),
  other('Other');

  const Location(this.label);
  final String label;
}