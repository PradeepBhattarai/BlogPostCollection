import 'dart:io';

import 'package:blogpost_colln/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogpost_colln/core/common/widgets/loader.dart';
import 'package:blogpost_colln/core/constants/constants.dart';
import 'package:blogpost_colln/core/theme/app_pallet.dart';
import 'package:blogpost_colln/core/utils/pick_image.dart';
import 'package:blogpost_colln/core/utils/show_shackbar.dart';
import 'package:blogpost_colln/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogpost_colln/features/blog/presentation/pages/blog_page.dart';
import 'package:blogpost_colln/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? imageFile;

  final formKey = GlobalKey<FormState>();

  void uploadBlog() {
      if (formKey.currentState!.validate() &&
          selectedTopics.isNotEmpty &&
          imageFile != null) {
        final posterId =
            (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

        context.read<BlogBloc>().add(
          BlogUpload(
            image: imageFile!,
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            topics: selectedTopics,
            posterId: posterId,
          ),
        );
      }

  }


  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        imageFile = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            uploadBlog();
          }, icon: Icon(Icons.done_rounded)),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route)=>false,
              );
          }
        },
        builder: (context, state) {
          if(state is BlogLoading){
            return const  Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    imageFile != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: AppPallete.borderColor,
                                strokeWidth: 2,
                                dashPattern: [10, 4],
                                radius: Radius.circular(10),
                                strokeCap: StrokeCap.round,
                              ),

                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select Your Image',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:Constants.topics.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedTopics.contains(e)) {
                                            selectedTopics.remove(e);
                                          } else {
                                            selectedTopics.add(e);
                                          }
                                        });
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        color: selectedTopics.contains(e)
                                            ? WidgetStateProperty.all(
                                                AppPallete.gradient1,
                                              )
                                            : null,
                                        side: selectedTopics.contains(e)
                                            ? null
                                            : BorderSide(
                                                color: AppPallete.borderColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlogEditor(controller: titleController, hint: 'Blog Title'),
                    SizedBox(height: 20),
                    BlogEditor(
                      controller: contentController,
                      hint: 'Blog Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
