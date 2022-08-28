import 'package:Confessi/core/utils/add_commas_to_number.dart';

/// Post text max character length;
const int kPostTextMaxLength = 10000;

/// Post title max character length;
const int kPostTitleMaxLength = 100;

/// After pressing the info button, this bottom sheet is brough up, showing details about what it means to create a confession.
String kInfoSheet =
    'Please be civil when posting, but have fun. All confessions are completely anonymous (excluding the university details you add on the next page, such as year of study, faculty, etc.). Max title length: ${addCommasToNumber(kPostTitleMaxLength)} chararacters. Max body length: ${addCommasToNumber(kPostTextMaxLength)} characters.';
