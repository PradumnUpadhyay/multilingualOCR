class Repeat {
  static List<String> removeDublicate(List<String> config) {
    for (int i = 0; i < config.length; i++) {
      String cong = config[i];
      List<String> tem = cong.split('+');
      tem = tem.toSet().toList();
      if (tem.contains('Latin')) {
        tem.remove('eng');
      }
      if (tem.contains('Devanagari')) {
        tem.remove('hin');
      }
      config[i] = tem.join("+");
    }
    return config;
  }
}
