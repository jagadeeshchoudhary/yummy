import 'package:flutter/material.dart';

import 'package:yummy/components/components.dart';
import 'package:yummy/models/models.dart';

class PostSection extends StatelessWidget {
  const PostSection({
    super.key,
    required this.posts,
  });

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posts',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(
              post: posts[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          )
        ],
      ),
    );
  }
}
