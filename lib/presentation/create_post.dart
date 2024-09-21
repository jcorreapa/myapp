import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/presentation/publicaciones_list_page.dart';
import 'package:myapp/repository/post_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/post_model.dart';

final _isLoading = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class CreatePost extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: ReactiveFormBuilder(
        form: () => FormGroup({
          'title': FormControl<String>(validators: [Validators.required]),
          'description': FormControl<String>(),
        }),
        builder: (context, formGroup, child) {
          if (ref.watch(_isLoading)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network('https://picsum.photos/200'),
                const SizedBox(height: 20),
                const CustomReactiveTextField(
                  controlName: 'title',
                ),
                const SizedBox(height: 20),
                const CustomReactiveTextField(
                  controlName: 'description',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formGroup.valid) {
                      ref.read((_isLoading.notifier)).state = true;
                      ref
                          .read(respositoryProvider)
                          .createPost(
                            PostModel(
                              title: formGroup.control('title').value,
                              descripcion:
                                  formGroup.control('description').value,
                              rutaImagen: 'https://picsum.photos/200',
                              fecha: DateTime.now(),
                              comentarios: [''],
                              likes: 0,
                            ),
                          )
                          .then(
                        (value) {
                          ref.read(_isLoading.notifier).state = false;
                          if (value) {
                            ref.refresh(postsProviders);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al crear la publicación'),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomReactiveTextField extends StatelessWidget {
  final String controlName;

  const CustomReactiveTextField({super.key, required this.controlName});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControlName: controlName,
      decoration: InputDecoration(
        labelText: controlName,
// Suggested code may be subject to a license. Learn more: ~LicenseLog:378592793.
        border: const OutlineInputBorder(),
      ),
    );
  }
}
