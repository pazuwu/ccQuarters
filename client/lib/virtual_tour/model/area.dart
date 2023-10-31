class Area {
  final String id;
  final String? transformsid;
  final String name;
  final List<String> photoIds;

  Area({
    required this.id,
    this.transformsid,
    required this.name,
    this.photoIds = const [],
  });
}
