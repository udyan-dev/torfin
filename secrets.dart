// ignore_for_file: avoid_print

import 'dart:io';

/// Secrets Setup Script
/// Clones release secrets from private repository
void main(List<String> args) async {
  try {
    final setup = Secrets();
    await setup.run();
  } catch (e, stackTrace) {
    print('[ERROR] $e');
    print(stackTrace);
    exit(1);
  }
}

class Secrets {
  static const String repoUrl = 'https://github.com/udyan-dev/secrets.git';
  static const String repoName = 'secrets';

  late final String projectDir;
  late final String androidDir;
  late final String appDir;
  late final String libDir;
  late final String parentDir;

  Future<void> run() async {
    print('[INFO] Initializing secrets setup...');

    _initializePaths();
    await _executeSetup();

    print('[SUCCESS] Secrets setup complete.');
  }

  void _initializePaths() {
    final scriptPath = Platform.script.toFilePath();
    projectDir = Directory(scriptPath).parent.path;
    androidDir = '$projectDir${Platform.pathSeparator}android';
    appDir = '$androidDir${Platform.pathSeparator}app';
    libDir = '$projectDir${Platform.pathSeparator}lib';
    parentDir = Directory(projectDir).parent.path;
  }

  Future<void> _executeSetup() async {
    final repoClonePath = '$parentDir${Platform.pathSeparator}$repoName';

    final repoDir = Directory(repoClonePath);
    if (await repoDir.exists()) {
      print('[INFO] Removing old clone: $repoClonePath');
      await repoDir.delete(recursive: true);
    }

    print('[INFO] Cloning from $repoUrl');
    final cloneResult = await Process.run('git', [
      'clone',
      repoUrl,
      repoClonePath,
    ], workingDirectory: parentDir);

    if (cloneResult.exitCode != 0) {
      throw Exception(
        'Git clone failed with exit code ${cloneResult.exitCode}\n${cloneResult.stderr}',
      );
    }

    print('[INFO] Copying secret files...');

    final fileMappings = [
      _FileMapping(
        source: 'torfin${Platform.pathSeparator}key.properties',
        destination: '$androidDir${Platform.pathSeparator}key.properties',
        label: 'key.properties',
      ),
      _FileMapping(
        source: 'torfin${Platform.pathSeparator}google-services.json',
        destination: '$appDir${Platform.pathSeparator}google-services.json',
        label: 'google-services.json',
      ),
      _FileMapping(
        source: 'torfin${Platform.pathSeparator}upload-keystore.jks',
        destination: '$projectDir${Platform.pathSeparator}upload-keystore.jks',
        label: 'upload-keystore.jks',
      ),
      _FileMapping(
        source: 'torfin${Platform.pathSeparator}firebase_options.dart',
        destination: '$libDir${Platform.pathSeparator}firebase_options.dart',
        label: 'firebase_options.dart',
      ),
      _FileMapping(
        source: 'torfin${Platform.pathSeparator}secrets.env',
        destination: '$projectDir${Platform.pathSeparator}secrets.env',
        label: 'secrets.env',
      ),
      _FileMapping(
        source: 'torfin${Platform.pathSeparator}firebase.json',
        destination: '$projectDir${Platform.pathSeparator}firebase.json',
        label: 'firebase.json',
      ),
    ];

    for (final fileMapping in fileMappings) {
      await _copySecret(
        source: '$repoClonePath${Platform.pathSeparator}${fileMapping.source}',
        destination: fileMapping.destination,
        label: fileMapping.label,
      );
    }
  }

  Future<void> _copySecret({
    required String source,
    required String destination,
    required String label,
  }) async {
    final sourceFile = File(source);

    if (!await sourceFile.exists()) {
      throw Exception('Missing $label: $source');
    }

    final destFile = File(destination);
    final destDir = destFile.parent;
    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }

    await sourceFile.copy(destination);
    print('[SUCCESS] $label copied to $destination');
  }
}

class _FileMapping {
  final String source;
  final String destination;
  final String label;

  _FileMapping({
    required this.source,
    required this.destination,
    required this.label,
  });
}
