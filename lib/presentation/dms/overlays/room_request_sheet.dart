import 'package:confesi/application/dms/cubit/room_requests_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/core/styles/typography.dart';
import 'package:confesi/presentation/shared/behaviours/init_opacity.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/overlays/button_options_sheet.dart';

class RoomRequestsWidget extends StatefulWidget {
  const RoomRequestsWidget({Key? key}) : super(key: key); // Updated this line to correct the syntax

  @override
  State<RoomRequestsWidget> createState() => _RoomRequestsWidgetState();
}

class _RoomRequestsWidgetState extends State<RoomRequestsWidget> {
  Widget buildBody(BuildContext context, RoomRequestsState state) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: () {
          if (state is RoomRequestsLoading || state is RoomRequestsError) {
            return LoadingOrAlert(
              isLoading: state is RoomRequestsLoading,
              message: StateMessage("Error loading", () => context.read<RoomRequestsCubit>().loadData()),
            );
          } else if (state is RoomRequestsData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InitOpacity(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Allow DMs",
                              style: kTitle.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Allow new messages from users sent from your chattable confessions",
                              style: kBody.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(width: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoSwitch(
                    value: state.allowsRequests,
                    onChanged: (_) async => (await context.read<RoomRequestsCubit>().toggleRequests()).fold(
                      (_) => null, // do nothing on success
                      (errMsg) => mounted ? context.read<NotificationsCubit>().showErr(errMsg) : null,
                    ),
                    focusColor: Theme.of(context).colorScheme.secondary,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            );
          } else {
            throw Exception("Unhandled state");
          }
        }(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomRequestsCubit, RoomRequestsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: buildBody(context, state),
        );
      },
    );
  }
}

void showRoomRequestsSheet(BuildContext context) {
  context.read<RoomRequestsCubit>().loadData();
  showButtonOptionsSheet(context, [
    const AnimatedSize(
      duration: Duration(milliseconds: 250),
      child: RoomRequestsWidget(),
    ),
  ]);
}
