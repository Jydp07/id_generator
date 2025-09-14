extension ImageUrlExtension on String {
  /// Checks if the string is a valid image URL
  bool get isImageUrl {
    if (isEmpty) return false;
    
    // Common image file extensions
    final imageExtensions = [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg', 'ico', 'tiff', 'tif'
    ];
    
    // Check if URL ends with image extension
    final lowerCaseUrl = toLowerCase();
    final hasImageExtension = imageExtensions.any((ext) => 
        lowerCaseUrl.endsWith('.$ext') || 
        lowerCaseUrl.contains('.$ext?') || 
        lowerCaseUrl.contains('.$ext&'));
    
    if (hasImageExtension) return true;
    
    // Check for common image hosting patterns
    final imageHostingPatterns = [
      'imgur.com',
      'i.imgur.com',
      'images.unsplash.com',
      'picsum.photos',
      'via.placeholder.com',
      'placehold.it',
      'loremflickr.com',
      'picsum.photos',
    ];
    
    final hasImageHosting = imageHostingPatterns.any((pattern) => 
        lowerCaseUrl.contains(pattern));
    
    if (hasImageHosting) return true;
    
    // Check for data URL (base64 encoded images)
    if (startsWith('data:image/')) return true;
    
    return false;
  }
}
