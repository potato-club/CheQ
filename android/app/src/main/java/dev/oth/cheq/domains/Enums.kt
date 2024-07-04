package dev.oth.cheq.domains

/**
 * cheq
 * Created by isaac on 2023/08/25.
 */

enum class PermissionTypes {
    external,
    microphone,
    bluetooth,
    camera;

    fun getName() : String {
        return this.name.lowercase()
    }
}
enum class CameraTypes {
    ocr,
    default500;

    fun getName() : String {
        return this.name.lowercase()
    }
}
enum class GalleryTypes {
    default500;

    fun getName() : String {
        return this.name.lowercase()
    }
}

enum class UploadTypes {
    fcmToken,
    deviceId;

    fun getName() : String {
        return this.name.lowercase()
    }
}

public enum class ServerType {
    DEV, STAGE, PRODUCT
}
public enum class OnOffTypes {
    ON, OFF
}
