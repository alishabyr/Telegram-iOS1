import Foundation
import SGAppGroupIdentifier
import SGLogging

let APP_GROUP_IDENTIFIER = sgAppGroupIdentifier()

public class SGSimpleSettings {
    
    public static let shared = SGSimpleSettings()
    
    private init() {
        setDefaultValues()
        migrate()
        preCacheValues()
    }
    
    private func setDefaultValues() {
        UserDefaults.standard.register(defaults: SGSimpleSettings.defaultValues)
        // Just in case group defaults will be nil
        UserDefaults.standard.register(defaults: SGSimpleSettings.groupDefaultValues)
        if let groupUserDefaults = UserDefaults(suiteName: APP_GROUP_IDENTIFIER) {
            groupUserDefaults.register(defaults: SGSimpleSettings.groupDefaultValues)
        }
    }
    
    private func migrate() {
        let showRepostToStoryMigrationKey = "migrated_\(Keys.showRepostToStory.rawValue)"
        if let groupUserDefaults = UserDefaults(suiteName: APP_GROUP_IDENTIFIER) {
            if !groupUserDefaults.bool(forKey: showRepostToStoryMigrationKey) {
                self.showRepostToStoryV2 = self.showRepostToStory
                groupUserDefaults.set(true, forKey: showRepostToStoryMigrationKey)
                SGLogger.shared.log("SGSimpleSettings", "Migrated showRepostToStory. \(self.showRepostToStory) -> \(self.showRepostToStoryV2)")
            }
        } else {
            SGLogger.shared.log("SGSimpleSettings", "Unable to migrate showRepostToStory. Shared UserDefaults suite is not available for '\(APP_GROUP_IDENTIFIER)'.")
        }
    }
    
    private func preCacheValues() {
        // let dispatchGroup = DispatchGroup()

        let tasks = [
//            { let _ = self.allChatsFolderPositionOverride },
            { let _ = self.allChatsHidden },
            { let _ = self.hideTabBar },
            { let _ = self.bottomTabStyle },
            { let _ = self.compactChatList },
            { let _ = self.compactFolderNames },
            { let _ = self.disableSwipeToRecordStory },
            { let _ = self.rememberLastFolder },
            { let _ = self.quickTranslateButton },
            { let _ = self.stickerSize },
            { let _ = self.stickerTimestamp },
            { let _ = self.hideReactions },
            { let _ = self.disableGalleryCamera },
            { let _ = self.disableSendAsButton },
            { let _ = self.disableSnapDeletionEffect },
            { let _ = self.startTelescopeWithRearCam },
            { let _ = self.hideRecordingButton },
            { let _ = self.inputToolbar },
            { let _ = self.dismissedSGSuggestions },
            { let _ = self.customAppBadge }
        ]

        tasks.forEach { task in
            DispatchQueue.global(qos: .background).async(/*group: dispatchGroup*/) {
                task()
            }
        }

        // dispatchGroup.notify(queue: DispatchQueue.main) {}
    }
    
    public func synchronizeShared() {
        if let groupUserDefaults = UserDefaults(suiteName: APP_GROUP_IDENTIFIER) {
            groupUserDefaults.synchronize()
        }
    }
    
    public enum Keys: String, CaseIterable {
        case hidePhoneInSettings
        case showTabNames
        case startTelescopeWithRearCam
        case accountColorsSaturation
        case uploadSpeedBoost
        case downloadSpeedBoost
        case bottomTabStyle
        case rememberLastFolder
        case lastAccountFolders
        case localDNSForProxyHost
        case sendLargePhotos
        case outgoingPhotoQuality
        case storyStealthMode
        case canUseStealthMode
        case disableSwipeToRecordStory
        case quickTranslateButton
        case outgoingLanguageTranslation
        case hideReactions
        case showRepostToStory
        case showRepostToStoryV2
        case contextShowSelectFromUser
        case contextShowSaveToCloud
        case contextShowRestrict
        // case contextShowBan
        case contextShowHideForwardName
        case contextShowReport
        case contextShowReply
        case contextShowPin
        case contextShowSaveMedia
        case contextShowMessageReplies
        case contextShowJson
        case showSaveChatButton
        case disableScrollToNextChannel
        case disableScrollToNextTopic
        case disableChatSwipeOptions
        case disableDeleteChatSwipeOption
        case disableGalleryCamera
        case disableGalleryCameraPreview
        case disableSendAsButton
        case disableSnapDeletionEffect
        case stickerSize
        case stickerTimestamp
        case hideRecordingButton
        case hideTabBar
        case showDC
        case showCreationDate
        case showRegDate
        case regDateCache
        case compactChatList
        case compactFolderNames
        case allChatsTitleLengthOverride
//        case allChatsFolderPositionOverride
        case allChatsHidden
        case defaultEmojisFirst
        case messageDoubleTapActionOutgoing
        case wideChannelPosts
        case forceEmojiTab
        case forceBuiltInMic
        case secondsInMessages
        case hideChannelBottomButton
        case forceSystemSharing
        case confirmCalls
        case videoPIPSwipeDirection
        case legacyNotificationsFix
        case messageFilterKeywords
        case inputToolbar
        case pinnedMessageNotifications
        case mentionsAndRepliesNotifications
        case primaryUserId
        case status
        case dismissedSGSuggestions
        case duckyAppIconAvailable
        case transcriptionBackend
        case translationBackend
        case customAppBadge
    }
    
    public enum DownloadSpeedBoostValues: String, CaseIterable {
        case none
        case medium
        case maximum
    }
    
    public enum BottomTabStyleValues: String, CaseIterable {
        case telegram
        case ios
    }
    
    public enum AllChatsTitleLengthOverride: String, CaseIterable {
        case none
        case short
        case long
    }
    
    public enum AllChatsFolderPositionOverride: String, CaseIterable {
        case none
        case last
        case hidden
    }
    
    public enum MessageDoubleTapAction: String, CaseIterable {
        case `default`
        case none
        case edit
    }
    
    public enum VideoPIPSwipeDirection: String, CaseIterable {
        case up
        case down
        case none
    }

    public enum TranscriptionBackend: String, CaseIterable {
        case `default`
        case apple
    }

    public enum TranslationBackend: String, CaseIterable {
        case `default`
        case gtranslate
        case system
        // Make sure to update TranslationConfiguration
    }
        
    public enum PinnedMessageNotificationsSettings: String, CaseIterable {
        case `default`
        case silenced
        case disabled
    }
    
    public enum MentionsAndRepliesNotificationsSettings: String, CaseIterable {
        case `default`
        case silenced
        case disabled
    }
    
    public static let defaultValues: [String: Any] = [
        Keys.hidePhoneInSettings.rawValue: true,
        Keys.showTabNames.rawValue: true,
        Keys.startTelescopeWithRearCam.rawValue: false,
        Keys.accountColorsSaturation.rawValue: 100,
        Keys.uploadSpeedBoost.rawValue: false,
        Keys.downloadSpeedBoost.rawValue: DownloadSpeedBoostValues.none.rawValue,
        Keys.rememberLastFolder.rawValue: false,
        Keys.bottomTabStyle.rawValue: BottomTabStyleValues.telegram.rawValue,
        Keys.lastAccountFolders.rawValue: [:],
        Keys.localDNSForProxyHost.rawValue: false,
        Keys.sendLargePhotos.rawValue: false,
        Keys.outgoingPhotoQuality.rawValue: 70,
        Keys.storyStealthMode.rawValue: false,
        Keys.canUseStealthMode.rawValue: true,
        Keys.disableSwipeToRecordStory.rawValue: false,
        Keys.quickTranslateButton.rawValue: false,
        Keys.outgoingLanguageTranslation.rawValue: [:],
        Keys.hideReactions.rawValue: false,
        Keys.showRepostToStory.rawValue: true,
        Keys.contextShowSelectFromUser.rawValue: true,
        Keys.contextShowSaveToCloud.rawValue: true,
        Keys.contextShowRestrict.rawValue: true,
        // Keys.contextShowBan.rawValue: true,
        Keys.contextShowHideForwardName.rawValue: true,
        Keys.contextShowReport.rawValue: true,
        Keys.contextShowReply.rawValue: true,
        Keys.contextShowPin.rawValue: true,
        Keys.contextShowSaveMedia.rawValue: true,
        Keys.contextShowMessageReplies.rawValue: true,
        Keys.contextShowJson.rawValue: false,
        Keys.showSaveChatButton.rawValue: false,
        Keys.disableScrollToNextChannel.rawValue: false,
        Keys.disableScrollToNextTopic.rawValue: false,
        Keys.disableChatSwipeOptions.rawValue: false,
        Keys.disableDeleteChatSwipeOption.rawValue: false,
        Keys.disableGalleryCamera.rawValue: false,
        Keys.disableGalleryCameraPreview.rawValue: false,
        Keys.disableSendAsButton.rawValue: false,
        Keys.disableSnapDeletionEffect.rawValue: false,
        Keys.stickerSize.rawValue: 100,
        Keys.stickerTimestamp.rawValue: true,
        Keys.hideRecordingButton.rawValue: false,
        Keys.hideTabBar.rawValue: false,
        Keys.showDC.rawValue: false,
        Keys.showCreationDate.rawValue: true,
        Keys.showRegDate.rawValue: true,
        Keys.regDateCache.rawValue: [:],
        Keys.compactChatList.rawValue: false,
        Keys.compactFolderNames.rawValue: false,
        Keys.allChatsTitleLengthOverride.rawValue: AllChatsTitleLengthOverride.none.rawValue,
//        Keys.allChatsFolderPositionOverride.rawValue: AllChatsFolderPositionOverride.none.rawValue
        Keys.allChatsHidden.rawValue: false,
        Keys.defaultEmojisFirst.rawValue: false,
        Keys.messageDoubleTapActionOutgoing.rawValue: MessageDoubleTapAction.default.rawValue,
        Keys.wideChannelPosts.rawValue: false,
        Keys.forceEmojiTab.rawValue: false,
        Keys.hideChannelBottomButton.rawValue: false,
        Keys.secondsInMessages.rawValue: false,
        Keys.forceSystemSharing.rawValue: false,
        Keys.confirmCalls.rawValue: true,
        Keys.videoPIPSwipeDirection.rawValue: VideoPIPSwipeDirection.up.rawValue,
        Keys.messageFilterKeywords.rawValue: [],
        Keys.inputToolbar.rawValue: false,
        Keys.primaryUserId.rawValue: "",
        Keys.dismissedSGSuggestions.rawValue: [],
        Keys.duckyAppIconAvailable.rawValue: true,
        Keys.transcriptionBackend.rawValue: TranscriptionBackend.default.rawValue,
        Keys.translationBackend.rawValue: TranslationBackend.default.rawValue,
        Keys.customAppBadge.rawValue: "",
    ]
    
    public static let groupDefaultValues: [String: Any] = [
        Keys.legacyNotificationsFix.rawValue: false,
        Keys.pinnedMessageNotifications.rawValue: PinnedMessageNotificationsSettings.default.rawValue,
        Keys.mentionsAndRepliesNotifications.rawValue: MentionsAndRepliesNotificationsSettings.default.rawValue,
        Keys.status.rawValue: 1,
        Keys.showRepostToStoryV2.rawValue: true,
    ]
    
    @UserDefault(key: Keys.hidePhoneInSettings.rawValue)
    public var hidePhoneInSettings: Bool
    
    @UserDefault(key: Keys.showTabNames.rawValue)
    public var showTabNames: Bool
    
    @UserDefault(key: Keys.startTelescopeWithRearCam.rawValue)
    public var startTelescopeWithRearCam: Bool
    
    @UserDefault(key: Keys.accountColorsSaturation.rawValue)
    public var accountColorsSaturation: Int32
    
    @UserDefault(key: Keys.uploadSpeedBoost.rawValue)
    public var uploadSpeedBoost: Bool
    
    @UserDefault(key: Keys.downloadSpeedBoost.rawValue)
    public var downloadSpeedBoost: String
    
    @UserDefault(key: Keys.rememberLastFolder.rawValue)
    public var rememberLastFolder: Bool
    
    @UserDefault(key: Keys.bottomTabStyle.rawValue)
    public var bottomTabStyle: String
    
    public var lastAccountFolders = UserDefaultsBackedDictionary<String, Int32>(userDefaultsKey: Keys.lastAccountFolders.rawValue, threadSafe: false)
    
    @UserDefault(key: Keys.localDNSForProxyHost.rawValue)
    public var localDNSForProxyHost: Bool
    
    @UserDefault(key: Keys.sendLargePhotos.rawValue)
    public var sendLargePhotos: Bool
    
    @UserDefault(key: Keys.outgoingPhotoQuality.rawValue)
    public var outgoingPhotoQuality: Int32
    
    @UserDefault(key: Keys.storyStealthMode.rawValue)
    public var storyStealthMode: Bool
    
    @UserDefault(key: Keys.canUseStealthMode.rawValue)
    public var canUseStealthMode: Bool    
    
    @UserDefault(key: Keys.disableSwipeToRecordStory.rawValue)
    public var disableSwipeToRecordStory: Bool   
    
    @UserDefault(key: Keys.quickTranslateButton.rawValue)
    public var quickTranslateButton: Bool
    
    public var outgoingLanguageTranslation = UserDefaultsBackedDictionary<String, String>(userDefaultsKey: Keys.outgoingLanguageTranslation.rawValue, threadSafe: false)
    
    @UserDefault(key: Keys.hideReactions.rawValue)
    public var hideReactions: Bool

    // @available(*, deprecated, message: "Use showRepostToStoryV2 instead")
    @UserDefault(key: Keys.showRepostToStory.rawValue)
    public var showRepostToStory: Bool

    @UserDefault(key: Keys.showRepostToStoryV2.rawValue, userDefaults: UserDefaults(suiteName: APP_GROUP_IDENTIFIER) ?? .standard)
    public var showRepostToStoryV2: Bool

    @UserDefault(key: Keys.contextShowRestrict.rawValue)
    public var contextShowRestrict: Bool

    /*@UserDefault(key: Keys.contextShowBan.rawValue)
    public var contextShowBan: Bool*/

    @UserDefault(key: Keys.contextShowSelectFromUser.rawValue)
    public var contextShowSelectFromUser: Bool

    @UserDefault(key: Keys.contextShowSaveToCloud.rawValue)
    public var contextShowSaveToCloud: Bool

    @UserDefault(key: Keys.contextShowHideForwardName.rawValue)
    public var contextShowHideForwardName: Bool

    @UserDefault(key: Keys.contextShowReport.rawValue)
    public var contextShowReport: Bool

    @UserDefault(key: Keys.contextShowReply.rawValue)
    public var contextShowReply: Bool

    @UserDefault(key: Keys.contextShowPin.rawValue)
    public var contextShowPin: Bool

    @UserDefault(key: Keys.contextShowSaveMedia.rawValue)
    public var contextShowSaveMedia: Bool

    @UserDefault(key: Keys.contextShowMessageReplies.rawValue)
    public var contextShowMessageReplies: Bool
    
    @UserDefault(key: Keys.contextShowJson.rawValue)
    public var contextShowJson: Bool

    @UserDefault(key: Keys.showSaveChatButton.rawValue)
    public var showSaveChatButton: Bool
    
    @UserDefault(key: Keys.disableScrollToNextChannel.rawValue)
    public var disableScrollToNextChannel: Bool

    @UserDefault(key: Keys.disableScrollToNextTopic.rawValue)
    public var disableScrollToNextTopic: Bool

    @UserDefault(key: Keys.disableChatSwipeOptions.rawValue)
    public var disableChatSwipeOptions: Bool

    @UserDefault(key: Keys.disableDeleteChatSwipeOption.rawValue)
    public var disableDeleteChatSwipeOption: Bool

    @UserDefault(key: Keys.disableGalleryCamera.rawValue)
    public var disableGalleryCamera: Bool

    @UserDefault(key: Keys.disableGalleryCameraPreview.rawValue)
    public var disableGalleryCameraPreview: Bool

    @UserDefault(key: Keys.disableSendAsButton.rawValue)
    public var disableSendAsButton: Bool

    @UserDefault(key: Keys.disableSnapDeletionEffect.rawValue)
    public var disableSnapDeletionEffect: Bool
    
    @UserDefault(key: Keys.stickerSize.rawValue)
    public var stickerSize: Int32
    
    @UserDefault(key: Keys.stickerTimestamp.rawValue)
    public var stickerTimestamp: Bool    

    @UserDefault(key: Keys.hideRecordingButton.rawValue)
    public var hideRecordingButton: Bool
    
    @UserDefault(key: Keys.hideTabBar.rawValue)
    public var hideTabBar: Bool
    
    @UserDefault(key: Keys.showDC.rawValue)
    public var showDC: Bool
    
    @UserDefault(key: Keys.showCreationDate.rawValue)
    public var showCreationDate: Bool

    @UserDefault(key: Keys.showRegDate.rawValue)
    public var showRegDate: Bool

    public var regDateCache = UserDefaultsBackedDictionary<String, Data>(userDefaultsKey: Keys.regDateCache.rawValue, threadSafe: false)
    
    @UserDefault(key: Keys.compactChatList.rawValue)
    public var compactChatList: Bool

    @UserDefault(key: Keys.compactFolderNames.rawValue)
    public var compactFolderNames: Bool
    
    @UserDefault(key: Keys.allChatsTitleLengthOverride.rawValue)
    public var allChatsTitleLengthOverride: String
//    
//    @UserDefault(key: Keys.allChatsFolderPositionOverride.rawValue)
//    public var allChatsFolderPositionOverride: String
    @UserDefault(key: Keys.allChatsHidden.rawValue)
    public var allChatsHidden: Bool

    @UserDefault(key: Keys.defaultEmojisFirst.rawValue)
    public var defaultEmojisFirst: Bool
    
    @UserDefault(key: Keys.messageDoubleTapActionOutgoing.rawValue)
    public var messageDoubleTapActionOutgoing: String
    
    @UserDefault(key: Keys.wideChannelPosts.rawValue)
    public var wideChannelPosts: Bool

    @UserDefault(key: Keys.forceEmojiTab.rawValue)
    public var forceEmojiTab: Bool
    
    @UserDefault(key: Keys.forceBuiltInMic.rawValue)
    public var forceBuiltInMic: Bool
    
    @UserDefault(key: Keys.secondsInMessages.rawValue)
    public var secondsInMessages: Bool
    
    @UserDefault(key: Keys.hideChannelBottomButton.rawValue)
    public var hideChannelBottomButton: Bool

    @UserDefault(key: Keys.forceSystemSharing.rawValue)
    public var forceSystemSharing: Bool

    @UserDefault(key: Keys.confirmCalls.rawValue)
    public var confirmCalls: Bool
    
    @UserDefault(key: Keys.videoPIPSwipeDirection.rawValue)
    public var videoPIPSwipeDirection: String

    @UserDefault(key: Keys.legacyNotificationsFix.rawValue, userDefaults: UserDefaults(suiteName: APP_GROUP_IDENTIFIER) ?? .standard)
    public var legacyNotificationsFix: Bool
    
    @UserDefault(key: Keys.status.rawValue, userDefaults: UserDefaults(suiteName: APP_GROUP_IDENTIFIER) ?? .standard)
    public var status: Int64

    public var ephemeralStatus: Int64 = 1
    
    @UserDefault(key: Keys.messageFilterKeywords.rawValue)
    public var messageFilterKeywords: [String]
    
    @UserDefault(key: Keys.inputToolbar.rawValue)
    public var inputToolbar: Bool
    
    @UserDefault(key: Keys.pinnedMessageNotifications.rawValue, userDefaults: UserDefaults(suiteName: APP_GROUP_IDENTIFIER) ?? .standard)
    public var pinnedMessageNotifications: String
    
    @UserDefault(key: Keys.mentionsAndRepliesNotifications.rawValue, userDefaults: UserDefaults(suiteName: APP_GROUP_IDENTIFIER) ?? .standard)
    public var mentionsAndRepliesNotifications: String
    
    @UserDefault(key: Keys.primaryUserId.rawValue)
    public var primaryUserId: String

    @UserDefault(key: Keys.dismissedSGSuggestions.rawValue)
    public var dismissedSGSuggestions: [String]

    @UserDefault(key: Keys.duckyAppIconAvailable.rawValue)
    public var duckyAppIconAvailable: Bool

    @UserDefault(key: Keys.transcriptionBackend.rawValue)
    public var transcriptionBackend: String

    @UserDefault(key: Keys.translationBackend.rawValue)
    public var translationBackend: String

    @UserDefault(key: Keys.customAppBadge.rawValue)
    public var customAppBadge: String
}

extension SGSimpleSettings {
    public var isStealthModeEnabled: Bool {
        return storyStealthMode && canUseStealthMode
    }
    
    public static func makeOutgoingLanguageTranslationKey(accountId: Int64, peerId: Int64) -> String {
        return "\(accountId):\(peerId)"
    }
}

extension SGSimpleSettings {
    public var translationBackendEnum: SGSimpleSettings.TranslationBackend {
        return TranslationBackend(rawValue: translationBackend) ?? .default
    }
    
    public var transcriptionBackendEnum: SGSimpleSettings.TranscriptionBackend {
        return TranscriptionBackend(rawValue: transcriptionBackend) ?? .default
    }
}

public func getSGDownloadPartSize(_ default: Int64, fileSize: Int64?) -> Int64 {
    let currentDownloadSetting = SGSimpleSettings.shared.downloadSpeedBoost
    // Increasing chunk size for small files make it worse in terms of overall download performance
    let smallFileSizeThreshold = 1 * 1024 * 1024 // 1 MB
    switch (currentDownloadSetting) {
        case SGSimpleSettings.DownloadSpeedBoostValues.medium.rawValue:
            if let fileSize, fileSize <= smallFileSizeThreshold {
                return `default`
            }
            return 512 * 1024
        case SGSimpleSettings.DownloadSpeedBoostValues.maximum.rawValue:
            if let fileSize, fileSize <= smallFileSizeThreshold {
                return `default`
            }
            return 1024 * 1024
        default:
            return `default`
    }
}

public func getSGMaxPendingParts(_ default: Int) -> Int {
    let currentDownloadSetting = SGSimpleSettings.shared.downloadSpeedBoost
    switch (currentDownloadSetting) {
        case SGSimpleSettings.DownloadSpeedBoostValues.medium.rawValue:
            return 8
        case SGSimpleSettings.DownloadSpeedBoostValues.maximum.rawValue:
            return 12
        default:
            return `default`
    }
}

public func sgUseShortAllChatsTitle(_ default: Bool) -> Bool {
    let currentOverride = SGSimpleSettings.shared.allChatsTitleLengthOverride
    switch (currentOverride) {
        case SGSimpleSettings.AllChatsTitleLengthOverride.short.rawValue:
            return true
        case SGSimpleSettings.AllChatsTitleLengthOverride.long.rawValue:
            return false
        default:
            return `default`
    }
}
