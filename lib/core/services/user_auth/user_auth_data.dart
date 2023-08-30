import 'package:hive/hive.dart';

import 'user_auth_service.dart';

part 'user_auth_data.g.dart';

//? Whenever changed, run `flutter packages pub run build_runner build` to rebuild the generated file.

//! Whenever you change anything here, ENSURE the Hive ID fields are UNIQUE.

enum ThemePref { light, dark, system }

enum ProfanityFilter { on, off }

enum UnitSystem { metric, imperial }

enum DefaultPostFeed { trending, recents, sentiment }

enum DefaultCommentSort { trending, recents }

enum TextSize {
  small(0.75),
  regular(1),
  large(1.2),
  boomer(1.5);

  final double multiplier;

  const TextSize(this.multiplier);
}

enum ComponentCurviness {
  none(0),
  small(5),
  regular(15),
  alot(20);

  final double borderRadius;

  const ComponentCurviness(this.borderRadius);
}

@HiveType(typeId: 1)
class UserAuthData extends HiveObject with UserAuthState {
  @HiveField(0)
  final ThemePref themePref;

  @HiveField(6)
  final ProfanityFilter profanityFilter;

  @HiveField(7)
  final bool isShrunkView;

  @HiveField(8)
  final bool shakeToGiveFeedback;

  @HiveField(11)
  final UnitSystem unitSystem;

  @HiveField(14)
  final DefaultCommentSort defaultCommentSort;

  @HiveField(15)
  final DefaultPostFeed defaultPostFeed;

  @HiveField(16)
  final TextSize textSize;

  @HiveField(18)
  final ComponentCurviness componentCurviness;

  @HiveField(20)
  final bool categorySplashes;

  @HiveField(21)
  final bool blurImages;

  // default
  UserAuthData({
    this.themePref = ThemePref.dark,
    this.profanityFilter = ProfanityFilter.off,
    this.isShrunkView = false,
    this.shakeToGiveFeedback = true,
    this.unitSystem = UnitSystem.metric,
    this.defaultCommentSort = DefaultCommentSort.trending,
    this.defaultPostFeed = DefaultPostFeed.trending,
    this.textSize = TextSize.regular,
    this.componentCurviness = ComponentCurviness.regular,
    this.categorySplashes = false,
    this.blurImages = false,
  });
}

// copyWith
extension UserAuthDataCopyWith on UserAuthData {
  UserAuthData copyWith({
    ThemePref? themePref,
    ProfanityFilter? profanityFilter,
    bool? isShrunkView,
    bool? shakeToGiveFeedback,
    UnitSystem? unitSystem,
    DefaultCommentSort? defaultCommentSort,
    DefaultPostFeed? defaultPostFeed,
    TextSize? textSize,
    ComponentCurviness? componentCurviness,
    bool? categorySplashes,
    bool? blurImages,
  }) {
    return UserAuthData(
      themePref: themePref ?? this.themePref,
      profanityFilter: profanityFilter ?? this.profanityFilter,
      isShrunkView: isShrunkView ?? this.isShrunkView,
      shakeToGiveFeedback: shakeToGiveFeedback ?? this.shakeToGiveFeedback,
      unitSystem: unitSystem ?? this.unitSystem,
      defaultCommentSort: defaultCommentSort ?? this.defaultCommentSort,
      defaultPostFeed: defaultPostFeed ?? this.defaultPostFeed,
      textSize: textSize ?? this.textSize,
      componentCurviness: componentCurviness ?? this.componentCurviness,
      categorySplashes: categorySplashes ?? this.categorySplashes,
      blurImages: blurImages ?? this.blurImages,
    );
  }
}

class ComponentCurvinessAdapter extends TypeAdapter<ComponentCurviness> {
  @override
  final int typeId = 19; // Choose a unique typeId for the enum

  @override
  ComponentCurviness read(BinaryReader reader) {
    return ComponentCurviness.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, ComponentCurviness obj) {
    writer.writeInt(obj.index);
  }
}

class ThemePrefAdapter extends TypeAdapter<ThemePref> {
  @override
  final int typeId = 2; // Choose a unique typeId for the enum

  @override
  ThemePref read(BinaryReader reader) {
    return ThemePref.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, ThemePref obj) {
    writer.writeInt(obj.index);
  }
}

class DefaultCommentSortAdapter extends TypeAdapter<DefaultCommentSort> {
  @override
  final int typeId = 13; // Choose a unique typeId for the enum

  @override
  DefaultCommentSort read(BinaryReader reader) {
    return DefaultCommentSort.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, DefaultCommentSort obj) {
    writer.writeInt(obj.index);
  }
}

class TextSizeAdapter extends TypeAdapter<TextSize> {
  @override
  final int typeId = 17; // Choose a unique typeId for the enum

  @override
  TextSize read(BinaryReader reader) {
    return TextSize.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, TextSize obj) {
    writer.writeInt(obj.index);
  }
}

class DefaultPostFeedAdapter extends TypeAdapter<DefaultPostFeed> {
  @override
  final int typeId = 12; // Choose a unique typeId for the enum

  @override
  DefaultPostFeed read(BinaryReader reader) {
    return DefaultPostFeed.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, DefaultPostFeed obj) {
    writer.writeInt(obj.index);
  }
}

class ProfanityFilterAdapter extends TypeAdapter<ProfanityFilter> {
  @override
  final int typeId = 5; // Choose a unique typeId for the enum

  @override
  ProfanityFilter read(BinaryReader reader) {
    return ProfanityFilter.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, ProfanityFilter obj) {
    writer.writeInt(obj.index);
  }
}

class UnitSystemAdapter extends TypeAdapter<UnitSystem> {
  @override
  final int typeId = 9; // Choose a unique typeId for the enum

  @override
  UnitSystem read(BinaryReader reader) {
    return UnitSystem.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, UnitSystem obj) {
    writer.writeInt(obj.index);
  }
}
