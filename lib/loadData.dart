class loadData {
  String file;

  loadData({this.file});

  loadData.fromJson(Map<String, dynamic> json) {
    file = json["file"];
  }
}
