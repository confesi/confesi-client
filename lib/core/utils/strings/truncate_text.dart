String truncateText(String text, int maxLength, {int maxNewlines = 5, String ellipsis = '...'}) {
  int charCount = 0;
  int numOfNewlines = 0;
  StringBuffer buffer = StringBuffer();

  // Adjust maxLength to account for the ellipsis.
  int effectiveMaxLength = maxLength - ellipsis.length;
  if (effectiveMaxLength < 0) effectiveMaxLength = 0;

  for (var i in text.runes) {
    if (charCount >= effectiveMaxLength || numOfNewlines >= maxNewlines) break;

    if (String.fromCharCode(i) == '\n') {
      numOfNewlines++;
    }
    charCount++;
    buffer.writeCharCode(i);
  }

  // If the text was truncated, append an ellipsis.
  if (charCount >= effectiveMaxLength || numOfNewlines >= maxNewlines || charCount < text.runes.length) {
    buffer.write(ellipsis);
  }

  return buffer.toString();
}

int truncateTextLastIndex(String text, int maxLength, {String ellipsis = '...'}) {
  if (text.length <= maxLength) {
    return text.length - 1; // returning the last index of the text
  } else {
    return maxLength - 1; // returning the last index before truncation
  }
}

String removeSubsequentNewLines(String text) {
  return text.replaceAll(RegExp(r'\n{2,}'), '\n');
}
