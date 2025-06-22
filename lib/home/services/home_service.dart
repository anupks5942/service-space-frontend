import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/api_routes.dart';
import '../../../core/services/dio_service.dart';
import '../../../core/services/logger.dart';
import '../models/home_model.dart';

class HomeService {
  final Dio _dio = DioService.dio;

  Future<Either<String, List<HomeModel>>> getServices() async {
    try {
      final response = await _dio.get(ApiRoutes.service);

      if (response.statusCode == 200) {
        final services =
            (response.data as List<dynamic>? ?? [])
                .map((json) => HomeModel.fromJson(json))
                .toList();
        return Right(services);
      } else {
        final message = DioService.getErrorMessageFromStatusCode(
          response.statusCode,
        );
        return Left(message);
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while fetching services: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Fetch services error: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }
}
