import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading());

  int page = 1;
  List<ProductModel> listProduct = [];
  List<CommentModel> listComment = [];
  PaginationModel? pagination;
  UserModel? user;

  @override
  Stream<Transition<ProfileEvent, ProfileState>> transformEvents(
    events,
    transitionFn,
  ) {
    final nonDebounceStream = events.where(
      (event) => event is! OnProfileSearch,
    );
    final debounceStream = events.where((event) {
      return event is OnProfileSearch;
    }).debounceTime(
      const Duration(milliseconds: 1000),
    );
    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    ///OnLoad
    if (event is OnLoad) {
      page = 1;

      if (event.listing) {
        if (listProduct.isEmpty) {
          yield ProfileLoading();
        }

        ///Listing Load
        final result = await ListRepository.loadAuthorList(
          page: page,
          perPage: ListSetting.perPage,
          keyword: event.keyword,
          userID: event.userID,
          filter: event.filter,
        );
        if (result != null) {
          listProduct = result[0];
          pagination = result[1];
          user = result[2];
          user!.updateUser(total: pagination!.total);

          ///Notify
          yield ProfileSuccess(
            user: user!,
            listProduct: listProduct,
            listComment: listComment,
            canLoadMore: pagination!.page < pagination!.maxPage,
          );
        }
      } else {
        if (listComment.isEmpty) {
          yield ProfileLoading();
        }

        ///Review Load
        final response = await ReviewRepository.loadAuthorReview(
          page: page,
          perPage: ListSetting.perPage,
          keyword: event.keyword,
          userID: event.userID,
        );
        if (response.success) {
          listComment = List.from(response.data ?? []).map((item) {
            return CommentModel.fromJson(item);
          }).toList();

          pagination = response.pagination;

          ///Notify
          yield ProfileSuccess(
            user: user!,
            listProduct: listProduct,
            listComment: listComment,
            canLoadMore: pagination!.page < pagination!.maxPage,
          );
        } else {
          AppBloc.messageBloc.add(OnMessage(message: response.message));
        }
      }
    }

    ///On Search
    if (event is OnProfileSearch) {
      page = 1;

      if (event.listing) {
        if (listProduct.isEmpty) {
          yield ProfileLoading();
        }

        ///Listing Load
        final result = await ListRepository.loadAuthorList(
          page: page,
          perPage: ListSetting.perPage,
          keyword: event.keyword,
          userID: event.userID,
          filter: event.filter,
        );
        if (result != null) {
          listProduct = result[0];
          pagination = result[1];
          user = result[2];
          user!.updateUser(total: pagination!.total);

          ///Notify
          yield ProfileSuccess(
            user: user!,
            listProduct: listProduct,
            listComment: listComment,
            canLoadMore: pagination!.page < pagination!.maxPage,
          );
        }
      } else {
        if (listComment.isEmpty) {
          yield ProfileLoading();
        }

        ///Review Load
        final response = await ReviewRepository.loadAuthorReview(
          page: page,
          perPage: ListSetting.perPage,
          keyword: event.keyword,
          userID: event.userID,
        );
        if (response.success) {
          listComment = List.from(response.data ?? []).map((item) {
            return CommentModel.fromJson(item);
          }).toList();

          pagination = response.pagination;

          ///Notify
          yield ProfileSuccess(
            user: user!,
            listProduct: listProduct,
            listComment: listComment,
            canLoadMore: pagination!.page < pagination!.maxPage,
          );
        } else {
          AppBloc.messageBloc.add(OnMessage(message: response.message));
        }
      }
    }

    ///Load More
    if (event is OnLoadMore) {
      page += 1;

      ///Notify loading more
      yield ProfileSuccess(
        user: user!,
        listProduct: listProduct,
        listComment: listComment,
        canLoadMore: pagination!.page < pagination!.maxPage,
        loadingMore: true,
      );

      if (event.listing) {
        ///Listing Load
        final result = await ListRepository.loadAuthorList(
          page: page,
          perPage: ListSetting.perPage,
          keyword: event.keyword,
          userID: event.userID,
          filter: event.filter,
        );
        if (result != null) {
          listProduct.addAll(result[0]);
          pagination = result[1];
          user = result[2];
          user!.updateUser(total: pagination!.total);

          ///Notify
          yield ProfileSuccess(
            user: user!,
            listProduct: listProduct,
            listComment: listComment,
            canLoadMore: pagination!.page < pagination!.maxPage,
          );
        }
      } else {
        ///Review Load
        final response = await ReviewRepository.loadAuthorReview(
          page: page,
          perPage: ListSetting.perPage,
          keyword: event.keyword,
          userID: event.userID,
        );
        if (response.success) {
          final moreList = List.from(response.data ?? []).map((item) {
            return CommentModel.fromJson(item);
          }).toList();

          listComment.addAll(moreList);
          pagination = response.pagination;

          ///Notify
          yield ProfileSuccess(
            user: user!,
            listProduct: listProduct,
            listComment: listComment,
            canLoadMore: pagination!.page < pagination!.maxPage,
          );
        } else {
          AppBloc.messageBloc.add(OnMessage(message: response.message));
        }
      }
    }
  }
}
