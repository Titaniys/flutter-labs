class Country {
  final String name;
  final String capital;
  final String flag;
  final String population;
  final String languages;
  final String currency;

  const Country({
    required this.name,
    required this.capital,
    required this.flag,
    required this.population,
    required this.languages,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Country && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}