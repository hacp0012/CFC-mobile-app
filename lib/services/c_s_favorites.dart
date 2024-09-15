class CSFavorites {
  static CSFavorites? _instance;
  CSFavorites._();
  static CSFavorites get instance => _instance ??= CSFavorites._();
  static CSFavorites get inst => instance;
  // ------------------------------------------------------------------------------------------------------------------------|

  String? _section;

  get echo {
    return this;
  }

  get com {
    return this;
  }

  get teaching {
    return this;
  }

  add(String id) {
    if(_section != null) {
      //
    }
  }

  remove(String id) {
    if(_section != null) {
      //
    }
  }

  bool exist(String id) {
    if(_section != null) {
      //
    }

    return true;
  }
}
