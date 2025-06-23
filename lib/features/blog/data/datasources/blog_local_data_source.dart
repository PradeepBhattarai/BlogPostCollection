import 'package:blogpost_colln/features/blog/data/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    if (!box.isOpen) {
      throw Exception("Hive box is not open");
    }

    final List<BlogModel> blogs = [];

    for (int i = 0; i < box.length; i++) {
      try {
        final jsonData = box.get(i.toString());
        if (jsonData != null) {
          blogs.add(BlogModel.fromJson(jsonData));
        }
      } catch (e) {
        print('Error loading blog at index $i: $e');
        // Optionally: continue or handle error accordingly
      }
    }

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    if (!box.isOpen) {
      throw Exception("Hive box is not open");
    }

    box.clear();

    final Map<String, dynamic> blogMap = {
      for (int i = 0; i < blogs.length; i++) i.toString(): blogs[i].toJson(),
    };

    box.putAll(blogMap);
  }
}