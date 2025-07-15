import java.io.File
import java.nio.file.Files
import java.nio.file.StandardCopyOption

val userHome = System.getProperty("user.home")
val repoUrl = "git@github.com:udyan-dev/secrets.git"
val repoClonePath = File(userHome, "AppData/Local/Temp/secrets")
val appDir = File(rootDir, "app")
val libDir = File(rootDir.parentFile, "lib").apply { mkdirs() }

val filesToCopy = listOf(
    "torfin/key.properties" to File(rootDir, "key.properties"),
    "torfin/google-services.json" to File(appDir, "google-services.json"),
    "torfin/upload-keystore.jks" to File(appDir, "upload-keystore.jks"),
    "torfin/firebase_options.dart" to File(libDir, "firebase_options.dart"),
    "torfin/secrets.env" to File(rootDir.parentFile, "secrets.env"),
    "torfin/firebase.json" to File(rootDir.parentFile, "firebase.json")
)

fun copySecret(src: File, dest: File, label: String) {
    require(src.exists()) { "❌ Missing $label: ${src.absolutePath}" }
    Files.copy(src.toPath(), dest.toPath(), StandardCopyOption.REPLACE_EXISTING)
    logger.lifecycle("✅ $label → ${dest.absolutePath}")
}

logger.lifecycle("📦 Initializing secrets setup...")

if (repoClonePath.exists()) {
    logger.lifecycle("🧹 Removing old clone: ${repoClonePath.absolutePath}")
    repoClonePath.deleteRecursively()
}

logger.lifecycle("🔗 Cloning ➤ $repoUrl")
val cloneProcess =
    ProcessBuilder("git", "clone", repoUrl, repoClonePath.absolutePath).redirectErrorStream(true)
        .start()

val output = cloneProcess.inputStream.bufferedReader().use { it.readText() }
val exitCode = cloneProcess.waitFor()
logger.lifecycle("📄 Git Output:\n$output")

check(exitCode == 0) { "🚫 Git clone failed with exit code $exitCode" }

logger.lifecycle("📥 Copying secret files...")
filesToCopy.forEach { (relativePath, destination) ->
    val source = File(repoClonePath, relativePath)
    val label = relativePath.substringAfterLast('/')
    copySecret(source, destination, label)
}

logger.lifecycle("🎉 Secrets setup complete.")
