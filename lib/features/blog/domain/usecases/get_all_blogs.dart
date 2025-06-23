
import 'package:blogpost_colln/core/error/exception.dart';
import 'package:blogpost_colln/core/error/failure.dart';
import 'package:blogpost_colln/core/usercase/usecase.dart';
import 'package:blogpost_colln/features/blog/domain/entities/blog.dart';
import 'package:blogpost_colln/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>,NoParams>{
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);


  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async{
    try{

      return await blogRepository.getBlogs();

    }
    catch(e){
      throw ServerException(e.toString());
    }
    
  }

}