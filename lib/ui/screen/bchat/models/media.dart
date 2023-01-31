class Media {
  ///Video thumbnail image path
  String? thumbPath;

  ///Video path or image path
  String path;

  int size;

  Media({
    required this.path,
    this.thumbPath,
    required this.size,
  });
}
