import 'package:Confessi/features/feed/presentation/widgets/post_tile.dart';
import 'package:flutter/material.dart';

class ExploreRecents extends StatelessWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      child: const Center(
        child: PostTile(
          university: 'UVic',
          genre: 'Politics',
          time: '8h',
          faculty: 'Engineering',
          text:
              'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available. This generally helps designers in their creative process!',
          likes: 55,
          hates: 21,
          comments: '4 comments',
          year: 4,
        ),
      ),
    );
  }
}
