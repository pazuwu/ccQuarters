String getStringOfListWithCommaDivider(List<String> list) {
  String result = "";
  for (String s in list) {
    result += "$s, ";
  }
  return result.substring(0, result.length - 2);
}
