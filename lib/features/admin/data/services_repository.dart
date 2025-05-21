import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/base_response.dart';
import 'package:hotel_app/features/admin/data/services_service.dart';
import 'package:hotel_app/features/admin/model/service_model.dart';

final servicesRepository = Provider<ServicesRepository>(
      (ref) => ServicesRepositoryImpl(servicesService: ref.watch(servicesService)),
);

abstract class ServicesRepository {
  Future<BaseResponse<List<ServiceModel>>> getAllServices();
}

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesService servicesService;

  ServicesRepositoryImpl({required this.servicesService});

  @override
  Future<BaseResponse<List<ServiceModel>>> getAllServices() async {
    return await servicesService.getAllServices();
  }


}