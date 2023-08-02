import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/layout/swipebar.dart';
import '../../shared/other/item_picker.dart';

Future<dynamic> showPickerSheet(
  BuildContext context,
  final List<String> items,
  final Function(int idxSelected) onSelect,
  final VoidCallback onRemove,
  final bool canRemove,
) async {
  return showModalBottomSheet(
    barrierColor: Colors.black.withOpacity(0.7),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: bottomSafeArea(context), left: 15, right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Builder(builder: (context) {
              return _PickerSelector(
                items: items,
                onSelect: onSelect,
                onRemove: onRemove,
                canRemove: canRemove,
              );
            }),
          ),
        ),
      ],
    ),
  );
}

class _PickerSelector extends StatefulWidget {
  final List<String> items;
  final Function(int idxSelected) onSelect;
  final VoidCallback onRemove;
  final bool canRemove;

  const _PickerSelector({
    required this.items,
    required this.onSelect,
    required this.onRemove,
    required this.canRemove,
  });

  @override
  State<_PickerSelector> createState() => _PickerSelectorState();
}

class _PickerSelectorState extends State<_PickerSelector> {
  int currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SwipebarLayout(),
        Row(
          children: [
            Expanded(
              flex: widget.canRemove ? 1 : 0,
              child: WidgetOrNothing(
                showWidget: widget.canRemove,
                child: Row(
                  children: [
                    Expanded(
                      child: PopButton(
                        bottomPadding: 15,
                        justText: true,
                        onPress: () {
                          Navigator.pop(context);
                          widget.onRemove();
                        },
                        icon: CupertinoIcons.chevron_right,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        textColor: Theme.of(context).colorScheme.primary,
                        text: "Keep hidden",
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PopButton(
                bottomPadding: 15,
                justText: true,
                onPress: () {
                  // todo: add
                  Navigator.pop(context);
                  widget.onSelect(currentIdx);
                },
                icon: CupertinoIcons.chevron_right,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onSecondary,
                text: "Save selection",
              ),
            ),
          ],
        ),
        Expanded(
          child: ItemPicker(
            onChange: (index) => setState(() => currentIdx = index),
            options: widget.items,
          ),
        ),
      ],
    );
  }
}
