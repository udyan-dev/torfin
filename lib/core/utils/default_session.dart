import 'package:path_provider/path_provider.dart';

import '../../src/data/model/engine/engine.dart';
import '../../src/data/model/engine/session.dart';

initDefaultDownloadDir(Engine engine) async {
  try {
    // Fetch the current session
    var session = await engine.fetchSession();

    // Get the public downloads directory
    var downloadDir = await getDownloadsDirectory();
    if (downloadDir == null) {
      throw Exception('Could not retrieve the downloads directory.');
    }

    // Check if the current download directory is different
    if (session.downloadDir != downloadDir.path) {
      // Create a session update object
      var sessionUpdate = SessionBase(downloadDir: downloadDir.path);

      // Update the session
      await session.update(sessionUpdate);
    }
  } catch (e) {
    //
  }
}
