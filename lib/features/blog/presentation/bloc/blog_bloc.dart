import 'dart:io';
import 'package:blogpost_colln/core/usercase/usecase.dart';
import 'package:blogpost_colln/features/blog/domain/entities/blog.dart';
import 'package:blogpost_colln/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogpost_colln/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  }) :_uploadBlog=uploadBlog,
  _getAllBlogs=getAllBlogs, 
  super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(UploadBlogParams(
      image: event.image,
      title: event.title,
      content: event.content,
      topics: event.topics,
      posterId: event.posterId,
    ));
    result.fold((l) => emit(BlogFailure(l.message)), (r) => emit(BlogUploadSuccess()));
  }

  void _onFetchAllBlogs(BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    try{
      final result = await _getAllBlogs(NoParams());
      result.fold((l) => emit(BlogFailure(l.message)), (r) => emit(BlogDisplaySuccess(r)));

    } catch(e){
      emit(BlogFailure(e.toString()));
    }

  }

}
