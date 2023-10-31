class Scene {
  Scene({
    required this.id,
    this.parentId,
    required this.name,
    required this.photo360Url,
  });

  final String id;
  final String? parentId;
  final String name;
  final String photo360Url;

  @override
  String toString() {
    return name;
  }
}
