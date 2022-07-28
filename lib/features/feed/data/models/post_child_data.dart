import '../../../../core/results/exceptions.dart';
import 'post_model.dart';

enum ChildType {
  noChild,
  hasChild,
  childNeedsLoading,
}

class PostChildDataModel {
  const PostChildDataModel({
    required ChildType childType,
    required String? childId,
    required PostModel? childPost,
  });

  static ChildType _jsonChildTypeFormatter(String? data) {
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
      childType: _jsonChildTypeFormatter(json["child_type"]),
      childId: json["child_id"],
      childPost: json["child"],
    );
  }
}
