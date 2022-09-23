import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:flutter/material.dart';

class LeaderboardCircleTile extends StatelessWidget {
  const LeaderboardCircleTile({
    Key? key,
    required this.minSize,
    required this.placing,
    required this.universityName,
    required this.universityFullName,
    required this.points,
    required this.universityImagePath,
  }) : super(key: key);

  final String universityImagePath;
  final double minSize;
  final String placing;
  final String universityName;
  final String universityFullName;
  final String points;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => showInfoSheet(context, universityFullName,
          'I mean, congrats $universityName... ya\'ll are just sooooo cool, huh?!'),
      child: InitScale(
        child: Padding(
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
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(universityImagePath),
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
                universityName,
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
        ),
      ),
    );
  }
}
