import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';

class ArticleTile extends StatelessWidget {
  final ArticleEntity? article;
  final Function? onRemove;
  final Function? onArticleTapped;
  final bool isRemovable;

  const ArticleTile({
    super.key,
    this.article,
    this.onRemove,
    this.onArticleTapped,
    this.isRemovable = false,
  });

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return const SizedBox
          .shrink(); // Return an empty widget if article is null
    }

    return GestureDetector(
      onTap: () {
        if (onArticleTapped != null) {
          onArticleTapped!(article);
        }
      },
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: article!.urlToImage ?? "", // Provide fallback
              imageBuilder: (context, imageProvider) =>
                  _buildImage(imageProvider, context),
              progressIndicatorBuilder: (context, url, progress) =>
                  _buildPlaceholder(context),
              errorWidget: (context, url, error) => _buildErrorWidget(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article!.title ?? "No Title",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Butler',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article!.description ?? "No Description",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.timeline_outlined,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          article!.publishedAt ?? "Unknown Date",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isRemovable && onRemove != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => onRemove!(article),
              ),
          ],
        ),
      ),
    );
  }

  // Helper to build the main image
  Widget _buildImage(ImageProvider imageProvider, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  // Placeholder during image loading
  Widget _buildPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.08)),
          child: const CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  // Error widget for failed image loading
  Widget _buildErrorWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.08)),
          child: const Icon(Icons.error, color: Colors.redAccent),
        ),
      ),
    );
  }
}
