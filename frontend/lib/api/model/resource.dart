class Resource {
  final int id;
  final List<int> data;
  final String name;
  final String mimeType;
  final int size;

  Resource({
    required this.id,
    required this.data,
    required this.name,
    required this.mimeType,
    required this.size,
  });
}