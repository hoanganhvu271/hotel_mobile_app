enum BaseStatus {
  none,
  loading,
  success,
  error,
  emptyData,

}

extension BaseStatusExtension on BaseStatus {
  bool get isNone => this == BaseStatus.none;
  bool get isLoading => this == BaseStatus.loading;
  bool get isSuccess => this == BaseStatus.success;
  bool get isError => this == BaseStatus.error;
  bool get isEmptyData => this == BaseStatus.emptyData;
}

class BaseState<T> {
  final BaseStatus status;
  final T? data;
  final String? message;

  const BaseState({
    required this.status,
    this.data,
    this.message,
  });

  R when<R>({
    R Function()? none,
    R Function()? loading,
    R Function(T data)? success,
    R Function(String message)? error,
    R Function()? emptyData,
    required R Function() orElse,
  }) {
    switch (status) {
      case BaseStatus.none:
        return none?.call() ?? orElse();
      case BaseStatus.loading:
        return loading?.call() ?? orElse();
      case BaseStatus.success:
        return success?.call(data as T) ?? orElse();
      case BaseStatus.error:
        return error?.call(message ?? "Unknown error") ?? orElse();
      case BaseStatus.emptyData:
        return emptyData?.call() ?? orElse();
    }
  }

  factory BaseState.none() => const BaseState(status: BaseStatus.none);
  factory BaseState.loading() => const BaseState(status: BaseStatus.loading);
  factory BaseState.success(T data) => BaseState(status: BaseStatus.success, data: data);
  factory BaseState.error(String message) => BaseState(status: BaseStatus.error, message: message);
  factory BaseState.emptyData() => const BaseState(status: BaseStatus.emptyData);
}

