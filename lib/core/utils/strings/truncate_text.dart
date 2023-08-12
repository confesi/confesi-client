String truncateText(String text, int maxLength, {String ellipsis = '...'}) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}$ellipsis';
  }
}
