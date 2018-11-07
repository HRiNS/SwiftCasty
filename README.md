# Casty

[![CI Status](https://img.shields.io/travis/amirriyadh/Casty.svg?style=flat)](https://travis-ci.org/amirriyadh/Casty)
[![Version](https://img.shields.io/cocoapods/v/Casty.svg?style=flat)](https://cocoapods.org/pods/Casty)
[![License](https://img.shields.io/cocoapods/l/Casty.svg?style=flat)](https://cocoapods.org/pods/Casty)
[![Platform](https://img.shields.io/cocoapods/p/Casty.svg?style=flat)](https://cocoapods.org/pods/Casty)
[![Swift](https://img.shields.io/badge/Swift-4-orange.svg)]()

# Getting Started
Casty is a simple swift library used to make the integration of google cast sdk much simpler with few lines of code, it provides necessary functions to set and play your media right through to your chromecast by using google cast sdk.

# Installation

Casty is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
pod 'google-cast-sdk'
pod 'Casty'
```

# How to use
First thing import GoogleCast and Casty
```swift
import GoogleCast
import Casty
```

Then inside your AppDelegate class in didFinishLaunchingWithOptions
```swift 
let appId = "12345678"
Casty.shared.setupCasty(appId: appId, useExpandedControls: true)

```
Now in ViewController class do the following:
- Initialize Casty
```swift 
Casty.shared.initialize()
```
- Add casty button to your ViewController
```swift 
let button = Casty.castButton
button?.tintColor = .red
let barButton = UIBarButtonItem(customView: button!)
navigationItem.rightBarButtonItem = barButton
```
- Load your media whenever session is started 
```swift 
let url = "https://commondatastorage.googleapis.com/gtv-videos-bucket/CastVideos/mp4/DesigningForGoogleCast.mp4"

let subtitleURL = "https://commondatastorage.googleapis.com/gtv-videos-bucket/CastVideos/tracks/DesigningForGoogleCast-en.vtt"


let subtitle = GCKMediaTrack(identifier: 1, contentIdentifier: subtitleURL , contentType: "text/vtt", type: GCKMediaTrackType.text, textSubtype: GCKMediaTextTrackSubtype.captions, name: "English", languageCode: "en", customData: nil)

//this image will show up in expanded controller as well as video thumb
let image = GCKImage(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/CastVideos/images/780x1200/DesigningForGoogleCast-887x1200.jpg")!, width: 780, height: 1200)

Casty.didStartSession = { _ in
Casty.shared.loadMedia(url: self.url, subtitles: [subtitle], activeSubtitleID: 1, title: "Dev", image: image)
Casty.shared.presentExpandedController()
}

```

At this point you can see cast button icon whenever there is an active chromecast device
and when you tap and connect a session, video will start to stream.

You can add default mini controller to your view controller 
```swift
Casty.shared.addMiniController(toParentViewController: self)
```
To periodically get position of streaming video
```swift 
Casty.enableMediaWatchPosition = true
Casty.mediaWatchPosition = { p in
print("position ----",p)
}
```

# Important Notes
- Make sure you are connected to the same wifi network as chromecast
- For adaptive media streaming, Google Cast requires the presence of CORS headers, but even simple mp4 media streams require CORS if they include Tracks. If you want to enable Tracks for any media, you must enable CORS for both your track streams and your media streams. So, if you do not have CORS headers available for your simple mp4 media on your server, and you then add a simple subtitle track, you will not be able to stream your media unless you update your server to include the appropriate CORS header.

- If you want advanced features then I recommend you to use [GoogleCast](https://developers.google.com/cast/docs/developers) without casty


## Author

amirriyadh, amir.whiz@gmail.com

## License

Casty is available under the MIT license. See the LICENSE file for more info. -->
