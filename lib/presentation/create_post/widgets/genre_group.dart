import 'package:Confessi/presentation/create_post/widgets/genre_tile.dart';
import 'package:flutter/material.dart';

class GenreGroup extends StatelessWidget {
  const GenreGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: const [
              GenreTile(text: "Relationships"),
              SizedBox(width: 10),
              GenreTile(text: "Classes"),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            children: const [
              GenreTile(text: "General", isSelected: true),
              SizedBox(width: 10),
              GenreTile(text: "Hot Takes"),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            children: const [
              GenreTile(text: "Politics"),
              SizedBox(width: 10),
              GenreTile(text: "Wholesome"),
            ],
          ),
        ),
      ],
    );
  }
}
