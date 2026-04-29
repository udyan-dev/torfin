import 'dart:io';

Future<void> main() async {
  final sourceDir = Directory('svg_sources');
  final targetDir = Directory('assets');
  if (!sourceDir.existsSync()) {
    exit(1);
  }

  final svgFiles = sourceDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.toLowerCase().endsWith('.svg'))
      .toList();

  if (svgFiles.isEmpty) {
    return;
  }

  int errorCount = 0;

  final futures = svgFiles.map((file) async {
    final relativePath = file.path.substring(sourceDir.path.length + 1);
    final targetFile = File(
      '${targetDir.path}${Platform.pathSeparator}$relativePath.vec',
    );

    if (!targetFile.parent.existsSync()) {
      targetFile.parent.createSync(recursive: true);
    }

    final result = await Process.run('dart', [
      'run',
      'vector_graphics_compiler',
      '-i',
      file.path,
      '-o',
      targetFile.path,
      '--no-optimize-masks',
      '--no-optimize-clips',
      '--no-optimize-overdraw',
      '--no-tessellate',
    ]);

    return {
      'exitCode': result.exitCode,
      'stdout': result.stdout,
      'stderr': result.stderr,
    };
  });

  final results = await Future.wait(futures);

  for (final res in results) {
    if (res['exitCode'] != 0) {
      final output = (res['stdout'] as String).trim();
      final err = (res['stderr'] as String).trim();
      if (output.isNotEmpty) {}
      if (err.isNotEmpty) {}
      errorCount++;
    }
  }

  if (errorCount > 0) {
    exit(1);
  }
}
