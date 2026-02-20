class Country {
  final String name;
  final String capital;
  final String flag;
  final String population;
  final String languages;
  final String currency;
  final String? region;
  final String? subregion;
  final double? lat;
  final double? lng;

  const Country({
    required this.name,
    required this.capital,
    required this.flag,
    required this.population,
    required this.languages,
    required this.currency,
    this.region,
    this.subregion,
    this.lat,
    this.lng,
  });

  Country copyWith({
    String? name,
    String? capital,
    String? flag,
    String? population,
    String? languages,
    String? currency,
    String? region,
    String? subregion,
    double? lat,
    double? lng,
  }) {
    return Country(
      name: name ?? this.name,
      capital: capital ?? this.capital,
      flag: flag ?? this.flag,
      population: population ?? this.population,
      languages: languages ?? this.languages,
      currency: currency ?? this.currency,
      region: region ?? this.region,
      subregion: subregion ?? this.subregion,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Country && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Country(name: $name, capital: $capital)';
}