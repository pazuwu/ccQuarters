class Scene {
  Scene({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  @override
  String toString() {
    return name;
  }
}
