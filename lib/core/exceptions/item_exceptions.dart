/// Custom exceptions for item-related operations
class ItemException implements Exception {
  final String message;

  ItemException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when attempting to add an item that already exists
class ItemExistsException extends ItemException {
  ItemExistsException() : super('Item already exists in this category');
}
