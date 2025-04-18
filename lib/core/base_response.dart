class BaseResponse<T>{
  final bool isSuccessful;
  final String? errorCode;
  final String? errorMessage;
  final T? successfulData;

  BaseResponse({
    required this.isSuccessful,
    this.errorCode,
    this.errorMessage,
    this.successfulData,
  });

}