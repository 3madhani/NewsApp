abstract class RemoteArticleEvent {
  const RemoteArticleEvent();
}

class GetRemoteArticleEvent extends RemoteArticleEvent {
  final String? country;
  const GetRemoteArticleEvent({
    this.country,
  });
}
