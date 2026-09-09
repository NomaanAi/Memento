import 'package:flutter_test/flutter_test.dart';
import 'package:memento/features/projects/domain/entities/project.dart';

void main() {
  group('Project Entity', () {
    test('should instantiate Project correctly', () {
      final now = DateTime.now();
      final project = Project(
        id: '123',
        name: 'Test Project',
        createdAt: now,
        updatedAt: now,
        userId: 'user1',
      );

      expect(project.id, '123');
      expect(project.name, 'Test Project');
      expect(project.progress, 0.0);
    });
  });
}
