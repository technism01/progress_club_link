class ResponseClass<T> {
  bool success = false;
  String message = "";
  T? data;

  ResponseClass({
    required this.message,
    required this.success,
    this.data,
  });
}
