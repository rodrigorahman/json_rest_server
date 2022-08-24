class CommandException implements Exception {
  final String message;
  CommandException({
    required this.message,
  });
}
