import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/repository/post_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';

final postsProviders =
    FutureProvider.autoDispose<List<PostModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  final respository = ref.watch(respositoryProvider);
  return await respository.getPosts();
});

class PublicacionesListPage extends ConsumerWidget {
  const PublicacionesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProviders);
    return posts.when(
      data: (listaPublicaciones) {
        return ListView.builder(
          itemCount: listaPublicaciones.length,
          itemBuilder: (context, index) {
            final publicacion = listaPublicaciones[index];
            final isEven = index % 2 == 0;
            return _PostWidget(publicacion: publicacion, isEven: isEven);
          },
        );
      },
      error: (error, _) => const Center(child: Text('Error')),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _PostWidget extends StatelessWidget {
  final PostModel publicacion;
  final bool isEven;
  const _PostWidget(
      {super.key, required this.publicacion, required this.isEven});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isEven ? Colors.white : Colors.grey[200],
      ),
      child: Column(
        children: [
          Text(publicacion.title),
          if (publicacion.descripcion != null) ...[
            Text(publicacion.descripcion!),
          ],
          SizedBox(height: 16),
          Image.network(publicacion.rutaImagen),
          SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(Icons.favorite_outline),
                    Text(publicacion.likes.toString())
                  ],
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return _ModalComentarios(
                        comentarios: publicacion.comentarios,
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.comment_outlined),
                    Text(publicacion.comentarios.length.toString()),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _ModalComentarios extends StatefulWidget {
  final List<String> comentarios;
  const _ModalComentarios({super.key, required this.comentarios});

  @override
  State<_ModalComentarios> createState() => _ModalComentariosState();
}

class _ModalComentariosState extends State<_ModalComentarios> {
  late List<String> comentarios;

  @override
  void initState() {
    comentarios = widget.comentarios;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Comentarios',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 20),
          ...comentarios.map(
            (comment) => Column(
              children: [
                Text(comment),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 30),
          ReactiveFormBuilder(
              form: () => FormGroup({
                    'comentarios': FormControl<String>(
                        value: '', validators: [Validators.required]),
                  }),
              builder: (context, form, child) {
                return Row(
                  children: [
                    Expanded(
                      child: ReactiveTextField(
                        formControlName: 'comentarios',
                        decoration: InputDecoration(
                          labelText: 'Escribe tu comentario',
                        ),
                      ),
                    ),
                    ReactiveValueListenableBuilder<String>(
                        formControlName: 'comentarios',
                        builder: (context, contol, child) {
                          final isValid = contol.valid;
                          return IconButton(
                            onPressed: isValid
                                ? () {
                                    setState(() {
                                      comentarios.add(contol.value!);
                                    });
                                    contol.reset();
                                  }
                                : null,
                            icon: Icon(
                              Icons.send,
                              color: isValid ? Colors.purple : null,
                            ),
                          );
                        })
                  ],
                );
              }),
        ],
      ),
    );
  }
}
