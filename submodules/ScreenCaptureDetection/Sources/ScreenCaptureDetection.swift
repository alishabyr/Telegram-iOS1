import Foundation
import SwiftSignalKit
import UIKit

public enum ScreenCaptureEvent {
    case still
    case video
}

private func screenRecordingActive() -> Signal<Bool, NoError> {
    return .single(false) |> runOn(Queue.mainQueue())
}

public func screenCaptureEvents() -> Signal<ScreenCaptureEvent, NoError> {
    return .never()
}

public final class ScreenCaptureDetectionManager {
    public var isRecordingActive = false

    public init(check: @escaping () -> Bool) {
        self.isRecordingActive = false
    }

    deinit {
    }
}
