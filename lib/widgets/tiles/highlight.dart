import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class HighlightTile extends StatelessWidget {
  const HighlightTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Stack(
          children: [
            Container(
              height: 120,
              width: 175,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                image: DecorationImage(
                  image: AssetImage("assets/images/universities/uvic.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "UVic ∙ 92% likes",
                    style: kHeader.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Container(
              height: 32,
              width: 175,
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Relationships 💕",
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
