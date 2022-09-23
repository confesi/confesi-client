import 'package:Confessi/domain/feed/entities/post_child.dart';

import '../../../constants/feed/enums.dart';
import '../../../core/results/exceptions.dart';
import '../../../constants/feed/general.dart';
import '../../shared/models/post_model.dart';

class PostChildDataModel extends PostChild {
  const PostChildDataModel({
    required ChildType childType,
    required String? childId,
    required PostModel? childPost,
  }) : super(
          childType: childType,
          childId: childId,
          childPost: childPost,
        );

  static ChildType _childTypeFormatter(String? data) {
    switch (data) {
      case "no child":
        return ChildType.noChild;
      case "has child":
        return ChildType.hasChild;
      case "child needs loading":
        return ChildType.childNeedsLoading;
      default:
        throw ServerException();
    }
  }

  factory PostChildDataModel.fromJson(Map<String, dynamic> json) {
    return PostChildDataModel(
      childType: _childTypeFormatter(json["child_type"]),
      childId: json["child_id"],
      childPost:
          json["child"] != null ? PostModel.fromJson(json["child"]) : null,
    );
  }
}
