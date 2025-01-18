import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navy/features/authentication/model/user_response.dart';
import 'package:navy/utils/gaps.dart';

import '../../../../core/helpers/route_helper.dart';

class FeedHeader extends StatelessWidget {
  final UserResponse? user;
  final VoidCallback onCreatePost;

  const FeedHeader({
    super.key,
    required this.user,
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.9),
            Theme.of(context).scaffoldBackgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          gapH24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome, ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: user?.user.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const TextSpan(text: ' '),
                          const WidgetSpan(
                            child: Icon(Icons.waving_hand,
                                color: Color(0xFFFFD700), size: 20),
                          ),
                        ],
                      ),
                    ),
                    gapH8,
                    Text(
                      'Share your thoughts with the world',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () =>
                      Get.toNamed(RouteHelper.getPersonalProfileRoute()),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: user?.user.avatar != null
                            ? CachedNetworkImageProvider(user!.user.avatar!)
                            : null,
                        child: user?.user.avatar == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          gapH24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: InkWell(
              onTap: onCreatePost,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: user?.user.avatar != null
                              ? CachedNetworkImageProvider(user!.user.avatar!)
                              : null,
                          child: user?.user.avatar == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                    ),
                    gapW16,
                    Expanded(
                      child: Text(
                        'What\'s on your mind?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    gapW16,
                    Icon(
                      Icons.photo_library_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          gapH16,
        ],
      ),
    );
  }
}
