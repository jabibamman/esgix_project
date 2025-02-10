import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfilePostsLoading extends ProfileState {}

class ProfilePostsLoaded extends ProfileState {
  final List<PostModel> posts;
  final int page;
  final bool hasReachedMax;

  ProfilePostsLoaded({required this.posts, required this.page, required this.hasReachedMax});

  @override
  List<Object?> get props => [posts, page, hasReachedMax];

  ProfilePostsLoaded copyWith({List<PostModel>? posts, int? page, bool? hasReachedMax}) {
    return ProfilePostsLoaded(
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ProfilePostsError extends ProfileState {
  final String message;

  ProfilePostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileCompositeState extends ProfileState {
  final UserModel? user;
  final List<PostModel> tweets;
  final int tweetsPage;
  final bool tweetsHasReachedMax;
  final List<PostModel> likedPosts;
  final int likedPostsPage;
  final bool likedPostsHasReachedMax;
  final bool loadingTweets;
  final bool loadingLikedPosts;
  final String? error;

  ProfileCompositeState({
    this.user,
    this.tweets = const [],
    this.tweetsPage = 0,
    this.tweetsHasReachedMax = false,
    this.likedPosts = const [],
    this.likedPostsPage = 0,
    this.likedPostsHasReachedMax = false,
    this.loadingTweets = false,
    this.loadingLikedPosts = false,
    this.error,
  });

  ProfileCompositeState copyWith({
    UserModel? user,
    List<PostModel>? tweets,
    int? tweetsPage,
    bool? tweetsHasReachedMax,
    List<PostModel>? likedPosts,
    int? likedPostsPage,
    bool? likedPostsHasReachedMax,
    bool? loadingTweets,
    bool? loadingLikedPosts,
    String? error,
  }) {
    return ProfileCompositeState(
      user: user ?? this.user,
      tweets: tweets ?? this.tweets,
      tweetsPage: tweetsPage ?? this.tweetsPage,
      tweetsHasReachedMax: tweetsHasReachedMax ?? this.tweetsHasReachedMax,
      likedPosts: likedPosts ?? this.likedPosts,
      likedPostsPage: likedPostsPage ?? this.likedPostsPage,
      likedPostsHasReachedMax: likedPostsHasReachedMax ?? this.likedPostsHasReachedMax,
      loadingTweets: loadingTweets ?? this.loadingTweets,
      loadingLikedPosts: loadingLikedPosts ?? this.loadingLikedPosts,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    user,
    tweets,
    tweetsPage,
    tweetsHasReachedMax,
    likedPosts,
    likedPostsPage,
    likedPostsHasReachedMax,
    loadingTweets,
    loadingLikedPosts,
    error,
  ];
}