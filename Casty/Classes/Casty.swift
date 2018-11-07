//
//  Casty.swift
//  Casty
//
//  Created by Amir Riyadh on 9/29/18.
//

import UIKit
import GoogleCast

public class Casty: NSObject {
    
    public static var shared = Casty()
    
    public static var castButton : GCKUICastButton?
    public static var enableMediaWatchPosition: Bool = false
    public static var miniControllerIsShowing: Bool = true
    public static var miniControllerHeight: CGFloat = 70
    public static var didStartSession : ((GCKSession?)->())?
    public static var willStartSession : ((GCKSession?)->())?
    public static var didFailToStart : ((GCKSession?,Error?)->())?
    public static var didEndSession : ((GCKSession?,Error?)->())?
    public static var willEndSession : ((GCKSession?)->())?
    public static var didResumeSession : ((GCKSession?)->())?
    public static var willResumeSession : ((GCKSession?)->())?
    /// inorder to use this clouser you must set enableMediaWatchPosition to true
    public static var mediaWatchPosition : ((TimeInterval?)->())?
    
    private static var subtitleStyle : GCKMediaTextTrackStyle?
    private static var sessionManager : GCKSessionManager?
    private static var miniController : GCKUIMiniMediaControlsViewController?
    private static var expandedController : GCKUIExpandedMediaControlsViewController?
    
    /**
     Initialize the library
     - returns: Nothing
     */
    public func initialize() {
        Casty.castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        Casty.sessionManager = GCKCastContext.sharedInstance().sessionManager
        Casty.sessionManager?.add(self)
        Casty.miniController = GCKCastContext.sharedInstance().createMiniMediaControlsViewController()
    }
    
    /**
     Loads mp4 video and starts playback of a new media item with the specified options.
     
     - parameters:
     - url: Mp4 video url
     - subtitles: Array of subtitles (default: empty array)
     - activeSubtitleID: The default activated subtile id (default: no id)
     - playPosition: Start the loaded media at a specific position (default: 0)
     - title: Video title (default:empty string)
     - image: Video thumb image (optional)
     - streamType: determine wether video is live or buffered (default: none)
     - returns: Nothing
     */
    public func loadMedia(url: String, subtitles: [GCKMediaTrack] = [], activeSubtitleID: NSNumber = 0, playPosition: TimeInterval = 0 , title: String = "" , image: GCKImage? ,streamType: GCKMediaStreamType = GCKMediaStreamType.none ) {
        playSelectedItemRemotely(url: url, subtitles: subtitles, subtitleStyle: Casty.subtitleStyle, activeSubtitleID: activeSubtitleID, playPosition: playPosition, title: title, image: image)
    }
    /**
     Loads custom media and starts playback of a new media item with the specified options.
     
     - parameters:
     - mediaInformation: Your custom media information
     - playPosition: Start the loaded media at a specific position (default: 0)
     - activeSubtitleID: The default activated subtile id (default: no id)
     - returns: Nothing
     */
    public func loadMedia(mediaInformation: GCKMediaInformation , playPosition: TimeInterval = 0 , activeSubtitleID: NSNumber = 0) {
        playSelectedItemRemotely(mediaInformation: mediaInformation, playPosition: playPosition, activeSubtitleID: activeSubtitleID)
    }
    /**
     Begins (or resumes) playback of the current media item.
     */
    public func mediaPlay () {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            castSession?.remoteMediaClient?.play()
        }else {
            print("no castSession!")
        }
    }
    
    /**
     Pauses playback of the current media item.
     */
    public func mediaPause () {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            castSession?.remoteMediaClient?.pause()
        }else {
            print("no castSession!")
        }
    }
    
    /**
     Stops playback of the current media item.
     */
    public func mediaStop () {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            castSession?.remoteMediaClient?.stop()
        }else {
            print("no castSession!")
        }
    }
    /**
     Ends the session.
     */
    public func disconnnect () {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            castSession?.end(with: GCKSessionEndAction.disconnect)
        }else {
            print("no castSession!")
        }
    }
    /**
     Returns the approximate stream position as calculated from the last received stream information and the elapsed wall-time since that update. Returns 0 if the channel is not connected or if no media is currently loaded.
     
     - returns: Approximal stream position as TimeInterval
     */
    public func mediaCurrentPosition ()->TimeInterval {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            return (castSession?.remoteMediaClient?.approximateStreamPosition())!
        }else {
            print("no castSession!")
            return 0
        }
    }
    /**
     Seeks to a new position within the current media item.
     
     - parameters:
     - interval: specific play posistion
     - returns: Nothing
     */
    public func mediaSeek(interval: TimeInterval) {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            let op = GCKMediaSeekOptions()
            op.interval = interval
            castSession?.remoteMediaClient?.seek(with: op)
        }else {
            print("no castSession!")
        }
    }
    /**
     Basically set background and forground colors for specific subtitle
     
     - parameters:
     - backgroundColor: Background color as CGColor
     - foregroundColor: Foreground color as CGColor
     - outlineColor: Outline color aas
     - returns: Nothing
     */
    public func setSubtitleTextStyle (backgroundColor: CGColor,foregroundColor:CGColor, outlineColor: CGColor? ) {
        Casty.subtitleStyle = GCKMediaTextTrackStyle()
        Casty.subtitleStyle?.backgroundColor = GCKColor.init(cgColor: backgroundColor)
        Casty.subtitleStyle?.foregroundColor = GCKColor.init(cgColor: foregroundColor)
        if outlineColor != nil {
            Casty.subtitleStyle?.edgeColor = GCKColor.init(cgColor: outlineColor!)
        }
        
    }
    /**
     Set custom subtitle style
     
     - parameters:
     - style: Your custom text track style
     - returns: Nothing
     */
    public func setSubtitleTextStyle (style: GCKMediaTextTrackStyle) {
        Casty.subtitleStyle = style
    }
    /**
     Present default expanded controller
     */
    public func presentExpandedController () {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
        }
    }
    
    /**
     Add default miniController to your parent view controller
     
     - parameters:
     - toParentViewController: Your parent view controller
     - important: You can adjast mini controller height by modifying miniControllerHeight variable value
     - returns: Nothing
     */
    public func addMiniController(toParentViewController: UIViewController) {
        var paddingBottom: CGFloat = 0
        let tabBar = toParentViewController.tabBarController?.tabBar
        if tabBar != nil {
            paddingBottom = (tabBar?.frame.height)!
        }
        let parent = toParentViewController.view
        parent?.addSubview((Casty.miniController?.view)!)
        Casty.miniController?.view.anchor(top: nil, leading: parent?.leadingAnchor, bottom: parent?.bottomAnchor, trailing: parent?.trailingAnchor, centerX: nil, centerY: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: paddingBottom, right: 0), size: CGSize(width: (parent?.frame.width)!, height: Casty.miniControllerHeight))
        updateMiniControllerVisibility(hide: true)
    }
    /**
     To get miniController and customize it the way you want instead of addMiniController method
     
     - returns: miniMediaControlsViewController
     */
    public func getMiniController()->GCKUIMiniMediaControlsViewController {
        if let m = Casty.miniController {
            return m
        }else {
            return GCKCastContext.sharedInstance().createMiniMediaControlsViewController()
        }
    }
    
    
    /**
     Hide/Show default mini controller
     
     - parameters:
     - hide: hiding trigger
     - important: You don't have to use this function since showing and hiding minicontroller will be handled by default
     - returns: Nothing
     */
    public func updateMiniControllerVisibility (hide: Bool) {
        if Casty.miniController != nil {
            if hide {
                Casty.miniController?.view.isHidden = true
                Casty.miniControllerIsShowing = false
            }else {
                Casty.miniController?.view.isHidden = false
                Casty.miniControllerIsShowing = true
            }
        }
    }
    /**
     check if cast session is connected
     
     - returns: true when is connected successfuly of connecting otherwise false
     */
    public func isCastEnabled() -> Bool {
        switch GCKCastContext.sharedInstance().castState {
        case GCKCastState.connected:
            print("cast connected")
            return true
        case GCKCastState.connecting:
            print("cast connecting")
            return true
        case GCKCastState.notConnected:
            print("cast notConnected")
            return false
        case GCKCastState.noDevicesAvailable:
            print("cast noDevicesAvailable")
            return false
        }
    }
    /**
     Setup Casty library
     
     - parameters:
     - appId: Your styled or custom receiver application id
     - useExpandedControls: Set to true if you want to use default expanded controller
     - important: Use in AppDelegate class
     - returns: Nothing
     */
    public func setupCasty (appId: String, useExpandedControls: Bool = false) {
        let discoveryCriteria = GCKDiscoveryCriteria(applicationID: appId)
        let castOptions = GCKCastOptions(discoveryCriteria: discoveryCriteria)
        GCKCastContext.setSharedInstanceWith(castOptions)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = useExpandedControls
        GCKLogger.sharedInstance().delegate = self
    }
    
    //private functions
    private func watchPosition () {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) && Casty.enableMediaWatchPosition {
            castSession?.remoteMediaClient?.add(self)
        }
    }
    
    private func playSelectedItemRemotely(url: String, subtitles: [GCKMediaTrack]?, subtitleStyle: GCKMediaTextTrackStyle? ,activeSubtitleID: NSNumber? , playPosition: TimeInterval? , title: String? , image: GCKImage?,streamType: GCKMediaStreamType = GCKMediaStreamType.none) {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            let options = GCKMediaLoadOptions()
            options.activeTrackIDs = activeSubtitleID != 0 ? [activeSubtitleID!] : [] as! [NSNumber]
            options.playPosition = playPosition!
            castSession?.remoteMediaClient?.loadMedia(self.buildMediaInformation(url: url, subtitles: subtitles, subtitleStyle: subtitleStyle, title: title, image: image), with: options)
        }
        else {
            print("no castSession!")
        }
    }
    
    private func playSelectedItemRemotely(mediaInformation: GCKMediaInformation , playPosition: TimeInterval = 0 , activeSubtitleID: NSNumber = 0) {
        let castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            let options = GCKMediaLoadOptions()
            options.activeTrackIDs = activeSubtitleID != 0 ? [activeSubtitleID] : [] as! [NSNumber]
            options.playPosition = playPosition
            castSession?.remoteMediaClient?.loadMedia(mediaInformation, with: options)
        }
        else {
            print("no castSession!")
        }
    }
    private func buildMediaInformation(url: String, subtitles: [GCKMediaTrack]? ,subtitleStyle: GCKMediaTextTrackStyle? , title: String? , image: GCKImage?,streamType: GCKMediaStreamType = GCKMediaStreamType.none) -> GCKMediaInformation {
        
        let metadata = GCKMediaMetadata(metadataType: GCKMediaMetadataType.movie)
        if !(title?.isEmpty)! {
            metadata.setString(title!, forKey: kGCKMetadataKeyTitle)
        }
        if image != nil {
            metadata.addImage(image!)
        }
        let mediaInfo = GCKMediaInformation(contentID: url,
                                            streamType: streamType,
                                            contentType: "video/mp4",
                                            metadata: metadata,
                                            adBreaks: nil,
                                            adBreakClips: nil,
                                            streamDuration: 0,
                                            mediaTracks: subtitles,
                                            textTrackStyle: subtitleStyle,
                                            customData: nil)
        return mediaInfo
    }
    
    
}

extension Casty : GCKSessionManagerListener, GCKRemoteMediaClientListener, GCKRequestDelegate, GCKCastDeviceStatusListener, GCKDiscoveryManagerListener, GCKLoggerDelegate {
    public func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        updateMiniControllerVisibility(hide: false)
        watchPosition()
        Casty.didStartSession?(session)
    }
    public func sessionManager(_ sessionManager: GCKSessionManager, willStart session: GCKSession) {
        Casty.willStartSession?(session)
    }
    public func sessionManager(_ sessionManager: GCKSessionManager, willEnd session: GCKSession) {
        Casty.willEndSession?(session)
    }
    public func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        updateMiniControllerVisibility(hide: true)
        Casty.didEndSession?(session,error)
    }
    public func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        updateMiniControllerVisibility(hide: false)
        watchPosition()
        Casty.didResumeSession?(session)
    }
    public func sessionManager(_ sessionManager: GCKSessionManager, willResumeSession session: GCKSession) {
        Casty.willResumeSession?(session)
    }
    public func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        Casty.didFailToStart?(session,error)
    }
    public func remoteMediaClient(_ client: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
        let position = mediaStatus?.streamPosition
        Casty.mediaWatchPosition?(position)
    }
    public func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print("Message from Chromecast = \(message)")
    }
}



