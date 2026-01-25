class KitchenToolEntity {
  final String toolId;
  final String toolName;
  final String imageUrl;

  const KitchenToolEntity({
    required this.toolId,
    required this.toolName,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KitchenToolEntity &&
          runtimeType == other.runtimeType &&
          toolId == other.toolId &&
          toolName == other.toolName &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => toolId.hashCode ^ toolName.hashCode ^ imageUrl.hashCode;
}
