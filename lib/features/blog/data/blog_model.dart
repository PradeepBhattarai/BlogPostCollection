import 'package:blogpost_colln/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.posterId,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    super.posterName,
  });


  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      title: map['title'] as String,
      posterId: map['poster_id'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String?,
      topics: List<String>.from(map['topics']?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at'] ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_id': posterId,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }



  BlogModel copyWith({
      String? id,
      String? title,
      String? posterId,
      String? content,
      String? imageUrl,
      List<String>? topics,
      DateTime? updatedAt,
      String? posterName,
    }) {
      return BlogModel(
        id: id ?? this.id,
        title: title ?? this.title,
        posterId: posterId ?? this.posterId,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        topics: topics ?? this.topics,
        updatedAt: updatedAt ?? this.updatedAt,
        posterName: posterName ?? this.posterName,
      );
    }


}

