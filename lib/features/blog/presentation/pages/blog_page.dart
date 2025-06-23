import 'package:blogpost_colln/core/common/widgets/loader.dart';
import 'package:blogpost_colln/core/theme/app_pallet.dart';
import 'package:blogpost_colln/core/utils/show_shackbar.dart';
import 'package:blogpost_colln/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogpost_colln/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blogpost_colln/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);
  static route()=>MaterialPageRoute(builder: (context)=>const BlogPage());

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Page'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
          icon:Icon(Icons.add_circle)),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if(state is BlogFailure){
            showSnackbar(context, state.error);
          }


        },
        builder: (context, state) {
          if(state is BlogLoading){
            return const Loader();
          }
          if(state is BlogDisplaySuccess){
            return ListView.builder(
              itemCount:state.blogs.length,
              itemBuilder: (context,index){
                final blog=state.blogs[index];
                return BlogCard(blog: blog,
                color:index %2==0?AppPallete.gradient1:AppPallete.gradient2);
      
              }
              
              );
          }
          return SizedBox();
         
        },
      )
    );
  }
}