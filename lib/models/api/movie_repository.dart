import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mini_project/models/tmdb_responses/detail_response.dart';
import 'package:mini_project/models/tmdb_responses/movie_response_model.dart';

abstract class MovieRepository {
  Future<Either<String, MovieResponseModel>> getDiscover({int page = 1});
  Future<Either<String, MovieResponseModel>> getPopular({int page = 1});
  Future<Either<String, DetailMovieModel>> getDetail({required int id});
}

class MovieRepositoryImpl implements MovieRepository {
  final Dio _dio;

  MovieRepositoryImpl(this._dio);

  @override
  Future<Either<String, MovieResponseModel>> getDiscover({int page = 1}) async {
    try {
      final result = await _dio.get(
        '/discover/movie',
        queryParameters: {'page': page},
      );

      if (result.statusCode == 200 && result.data != null) {
        final model = MovieResponseModel.fromMap(result.data);
        return Right(model);
      }

      return const Left("Error get Discover Movies");
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(e.response.toString());
      }
      return const Left("Another error on get Discover Movies");
    }
  }

  @override
  Future<Either<String, MovieResponseModel>> getPopular({int page = 1}) async {
    try {
      final result = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );

      if (result.statusCode == 200 && result.data != null) {
        final model = MovieResponseModel.fromMap(result.data);
        return Right(model);
      }

      return const Left("Error get Popular Movies");
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(e.response.toString());
      }
      return const Left("Another error on get Popular Movies");
    }
  }

  @override
  Future<Either<String, DetailMovieModel>> getDetail({required int id}) async {
    try {
      final result = await _dio.get(
        '/movie/$id',
      );

      if (result.statusCode == 200 && result.data != null) {
        final model = DetailMovieModel.fromMap(result.data);
        return Right(model);
      }

      return const Left("Error get Detail Movies");
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(e.response.toString());
      }
      return const Left("Another error on get Detail Movies");
    }
  }
}
