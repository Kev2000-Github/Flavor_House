
class SortConfig {
  final String name;
  final String value;

  SortConfig(this.name, this.value);

  factory SortConfig.latest(){
    return SortConfig("Mas recientes", "DESC");
  }

  factory SortConfig.oldest(){
    return SortConfig("Mas antiguos", "ASC");
  }
}