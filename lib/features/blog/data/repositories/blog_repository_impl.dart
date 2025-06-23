import 'dart:io';

import 'package:blogpost_colln/core/error/exception.dart';
import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/core/network/connection_checker.dart';
import 'package:blogpost_colln/features/blog/data/blog_model.dart';
import 'package:blogpost_colln/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blogpost_colln/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blogpost_colln/features/blog/domain/entities/blog.dart';
import 'package:blogpost_colln/features/blog/domain/repositories/blog_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:fpdart/fpdart.dart';

class BlogRepositoryImpl implements BlogRepository{
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource,this.connectionChecker);

  @override
  Future<Either<Failure, Blog>> uploadBlog({required File image, required String title, required String content, required List<String> topics, required String posterId,}) async{
   try{
    if(!await (connectionChecker.isConnected)){
      return left(Failure(message: 'No internet Connection'));
    }
    BlogModel blogModel=BlogModel(id: const Uuid().v1(), posterId:posterId,title: title, content: content, imageUrl: '', topics: topics, updatedAt: DateTime.now());

    final imageUrl= await blogRemoteDataSource.uploadBlogImage(image: image, blog: blogModel);

    blogModel=blogModel.copyWith(imageUrl: imageUrl);

    final uploadedBlog=await blogRemoteDataSource.uploadBlog(blogModel);

    return right(uploadedBlog);



   } on ServerException catch (e) {
      throw ServerException(e.message);

   }

}

  @override
Future<Either<Failure, List<Blog>>> getBlogs() async{
  try{
    if(!await (connectionChecker.isConnected)){
      final blogs=blogLocalDataSource.loadBlogs();
      return right(blogs);
    }


    final blogs = await blogRemoteDataSource.getBlogs();
    blogLocalDataSource.uploadLocalBlogs(blogs:blogs);
    return right(blogs);
   } on ServerException catch(e){
    return left(Failure(message: e.message));
  }
}
}