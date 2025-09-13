class File {
  final String name;
  final int length;
  final int bytesCompleted;
  final bool wanted;
  final List<int> piecesRange;
  const File({
    required this.name,
    required this.length,
    required this.bytesCompleted,
    required this.wanted,
    required this.piecesRange,
  });
}
