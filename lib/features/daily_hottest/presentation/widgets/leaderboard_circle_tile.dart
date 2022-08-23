import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/material.dart';

class LeaderboardCircleTile extends StatelessWidget {
  const LeaderboardCircleTile({
    Key? key,
    required this.minSize,
    required this.placing,
    required this.university,
    required this.points,
  }) : super(key: key);

  final double minSize;
  final String placing;
  final String university;
  final String points;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                constraints:
                    BoxConstraints(minWidth: minSize, minHeight: minSize),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 4,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  constraints:
                      BoxConstraints(minWidth: minSize, minHeight: minSize),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/universities/uvic.jpg"),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    shape: BoxShape.circle,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Theme.of(context).colorScheme.shadow,
                    //     blurRadius: 20,
                    //   )
                    // ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      placing,
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            university,
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            points,
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
