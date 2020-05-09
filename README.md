Roon Display
=============

![Alt text](/screen01.png?raw=true "Roon Display")
![Alt text](/screen03.png?raw=true "Roon Display")


A simple Roon Display App for Apple TV.  This app is not written by or affiliated with Roon Labs in any way.

This app is not a Roon Player endpoint, it is a web display. For more information, please read:  https://kb.roonlabs.com/Displays#Web_Display

This app is heavily stripped down and modified from the great work at https://github.com/jvanakker/tvOSBrowser and https://github.com/Moballo-LLC/tvOS-Browser.  App icon, top shelf image, etc provided by Lucho.  This app would not be possible without their hard work.  Kudos!

This software is provided as-is with no warranty or liability. Use at your own risk.


How to Install Roon Display
=============
This app uses a browser view that is not allowed in the Apple Store, so if you want to use it, you will need to roll up your sleeves a bit.   No programming is required, but you need to build and deploy the app using XCode.  Tested on an Apple TV 4K running tvOS 13.4.5.

1. From a Mac, download and install XCode 11.4.1 or newer.  You will need to be signed up as an Apple Developer, but you do not need to be paying any subscription.  However, note that non-paid subscriptions appear to only only allow the app to be valid for 7 days on your AppleTV, then you will need to redeploy it from XCode.
1. Copy or clone this project and open the RoonDisplay project in XCode.
1. Start a Roon Client in your Roon setup and go to Settings>Displays and copy the URL listed there.
1. Set this URL in the app around line 19 of ViewController.m
1. You will need to update the bundle and Team identity to your own for code signing.
1. Build and deploy.  You must first make your physical Apple TV known to XCode. If you have an older Apple TV, you will need to connect your Mac via USB cable.  If your Apple TV does not have a USB-C port or you don't have a cable, connect to your Apple TV wirelessly: http://www.redmondpie.com/how-to-wirelessly-connect-apple-tv-4k-to-xcode-on-mac/.  Then select your device by clicking on the target to the left of the stop icon on the toolbar to see a list of available devices.  If you have successfully connected your physical AppleTV to XCode, it will show up there.   Select it and click the play button to build the app and deploy it.
1. After a successful build and deploy, the App is on your AppleTV, you don't need to re-build it again in the future unless something changes in the XCode project or your developer profile expires (this could be as soon a week - when this happens the app will crash immediately and unceremoniously when you run it) 
1. Play some music on one of your Roon Players.  Click on the volume icon and you should see a display icon to click and select the display.   See https://kb.roonlabs.com/Displays#Web_Display for more info.

Additional Info
=============
- Tap the Play/Pause button on your Apple remote to bring up a basic menu.  Generally, you won't need this.  If you screw up entering the hardcoded Display URL above, you can manually set it here.   It currently is not saved if you set it this way.
- Bug: When you leave the app on AppleTV and come back to it,  the screen fades to black for a number of seconds then will come back - this is related to the network connection to Roon needing to be re-established.
- If you are running the app AND streaming from Roon to the Apple TV, Apple TV switches the screen to its own "Now Playing" sceen after a few minutes.  To my knowledge this tvOS behavior cannot be customized or overriden.

