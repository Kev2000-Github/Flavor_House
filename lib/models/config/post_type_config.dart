
class PostTypeConfig {
  final String name;
  final String value;

  PostTypeConfig(this.name, this.value);

  factory PostTypeConfig.Moment(){
    return PostTypeConfig("Publicacion", "MOMENT");
  }

  factory PostTypeConfig.Recipe(){
    return PostTypeConfig("Receta", "RECIPE");
  }

  factory PostTypeConfig.All(){
    return PostTypeConfig("Todos", "ALL");
  }
}