
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/features/blog/domain/entities/blog.dart';

abstract interface class BlogRepository {

  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String posterId,
  });

  Future<Either<Failure, List<Blog>>> getBlogs();

}