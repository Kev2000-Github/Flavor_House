
class PostTypeConfig {
  final String name;
  final String value;

  PostTypeConfig(this.name, this.value);

  factory PostTypeConfig.Moment(){
    return PostTypeConfig("Publicacion", "Moment");
  }

  factory PostTypeConfig.Recipe(){
    return PostTypeConfig("Receta", "Recipe");
  }

  factory PostTypeConfig.All(){
    return PostTypeConfig("Todos", "All");
  }
}