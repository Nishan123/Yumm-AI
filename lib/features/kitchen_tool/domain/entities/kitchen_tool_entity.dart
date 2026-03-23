class KitchenToolEntity {
  final String? uid;
  final String toolId;
  final String toolName;
  final String imageUrl;
  final bool isReady;

  const KitchenToolEntity({
    this.uid,
    required this.toolId,
    required this.toolName,
    required this.imageUrl,
    this.isReady = false,
  });

  KitchenToolEntity copyWith({
    String? uid,
    String? toolId,
    String? toolName,
    String? imageUrl,
    bool? isReady,
  }) {
    return KitchenToolEntity(
      uid: uid ?? this.uid,
      toolId: toolId ?? this.toolId,
      toolName: toolName ?? this.toolName,
      imageUrl: imageUrl ?? this.imageUrl,
      isReady: isReady ?? this.isReady,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KitchenToolEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          toolId == other.toolId &&
          toolName == other.toolName &&
          toolName == other.toolName &&
          imageUrl == other.imageUrl &&
          isReady == other.isReady;

  @override
  int get hashCode =>
      uid.hashCode ^
      toolId.hashCode ^
      toolName.hashCode ^
      imageUrl.hashCode ^
      isReady.hashCode;
}
