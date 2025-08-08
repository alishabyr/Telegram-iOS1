import Foundation

private let persistentMediaFolder = "MediaPersistent"

private func ensurePersistentDirectory() -> URL {
    let fileManager = FileManager.default
    let appSupport = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let directory = appSupport!.appendingPathComponent(persistentMediaFolder, isDirectory: true)
    if !fileManager.fileExists(atPath: directory.path) {
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try? directory.setResourceValues(resourceValues)
    }
    return directory
}

public func persistentMediaURL(fileName: String) -> URL {
    return ensurePersistentDirectory().appendingPathComponent(fileName)
}

public func migrateToPersistentMedia(url: URL) -> URL {
    let fileManager = FileManager.default
    let destination = persistentMediaURL(fileName: url.lastPathComponent)
    if fileManager.fileExists(atPath: url.path) {
        if !fileManager.fileExists(atPath: destination.path) {
            do {
                try fileManager.moveItem(at: url, to: destination)
            } catch {
                _ = try? fileManager.removeItem(at: destination)
                _ = try? fileManager.moveItem(at: url, to: destination)
            }
        } else {
            _ = try? fileManager.removeItem(at: url)
        }
    }
    return destination
}
