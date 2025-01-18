enum MediaType {
  image,
  video,
  unknown;

  static MediaType fromUrl(String url) {
    final lowercaseUrl = url.toLowerCase();

    if (lowercaseUrl.endsWith('.mp4') ||
        lowercaseUrl.endsWith('.mov') ||
        lowercaseUrl.endsWith('.avi') ||
        lowercaseUrl.endsWith('.mkv') ||
        lowercaseUrl.endsWith('.webm')) {
      return MediaType.video;
    }

    if (lowercaseUrl.endsWith('.jpg') ||
        lowercaseUrl.endsWith('.jpeg') ||
        lowercaseUrl.endsWith('.png') ||
        lowercaseUrl.endsWith('.gif') ||
        lowercaseUrl.endsWith('.webp') ||
        lowercaseUrl.endsWith('.img')) {
      return MediaType.image;
    }

    if (lowercaseUrl.contains('video') ||
        lowercaseUrl.contains('media') ||
        lowercaseUrl.contains('.mp4')) {
      return MediaType.video;
    }

    if (lowercaseUrl.contains('image') ||
        lowercaseUrl.contains('img') ||
        lowercaseUrl.contains('photo')) {
      return MediaType.image;
    }

    return MediaType.unknown;
  }
}
