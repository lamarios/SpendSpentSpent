bool isValidEmail(String value) {
  try {
    final regex = RegExp(
        '[a-z0-9!#\$%&\'*+/=?^_`{|}~-]+(?:.[a-z0-9!#\$%&\'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?');
    final matches = regex.allMatches(value);
    for (Match match in matches) {
      if (match.start == 0 && match.end == value.length) {
        return true;
      }
    }
    return false;
  } catch (e) {
    // Invalid regex
    assert(false, e.toString());
    return true;
  }
}
