String truncateText(String text, int maxLength, {String ellipsis = '...'}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}$ellipsis';
  }
}

int truncateTextLastIndex(String text, int maxLength, {String ellipsis = '...'}) {
  if (text.length <= maxLength) {
    return text.length - 1; // returning the last index of the text
  } else {
    return maxLength - 1; // returning the last index before truncation
  }
}
