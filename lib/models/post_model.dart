class PostModel {
  final String title;
  final String? descripcion;
  final String rutaImagen;
  final DateTime fecha;
  final List<String> comentarios;
  final int likes;

  PostModel({
    required this.title,
    this.descripcion,
    required this.rutaImagen,
    required this.fecha,
    required this.comentarios,
    required this.likes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      rutaImagen: json['rutaImagen'],
      fecha: DateTime.now(),
      comentarios: [json['comentarios']],
      likes: int.parse(json['likes']),
    );
  }
}
