class BaseResponse<T>{
  final bool isSuccessful;
  final String? errorCode;
  final String? errorMessage;
  final T? sucessfulData;

  BaseResponse({
    required this.isSuccessful,
    this.errorCode,
    this.errorMessage,
    this.sucessfulData,
  });

}