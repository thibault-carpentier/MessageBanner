Message Banner
==============

This library provides an **easy to use and fully customizable class to show notifications** views on top/bottom/center of the screen.

The messages banners are regrouped in 4 different type : **Error**, **Warning**, **Message** and **Success**.

Each different type of banner can have different and fully customizable appearance and behavior. (See configuration section)

Each banner can show a **title**, a **subtitle**, an **image** and a **button**.

![Demo](/Screenshots/liveDemo.gif "Message Banner demo")

ScreenShots
----------------
![Error](/Screenshots/ErrorMessageBanner.png?raw=true "Standart Error message banner")
![Warning](/Screenshots/WarningMessageBanner.png?raw=true "Standart Warning message banner")
![Message](/Screenshots/MessageMessageBanner.png?raw=true "Standart Message message banner")
![Success](/Screenshots/SuccessMessageBanner.png?raw=true "Standart Success message banner")

Installation
----------------
### From CocoaPods

The recommended approach for installating ```MessageBanner``` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation:

```bash
$ [sudo] gem install cocoapods
$ pod setup
```
Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add MessageBanner:

``` bash
platform :ios, '7.0'
pod 'MessageBanner', '~> 1.0'
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.



### Manually
#### Dependency :
The project use [HexColors](https://github.com/mRs-/HexColors) and [FXBlurView](https://github.com/nicklockwood/FXBlurView)
You need to also install them manually. Please consult their installation requirement on their github pages.

#### MBLMessageBanner manual installation
Download Message banner project. You can download it directly from his [github page](https://github.com/Loadex/Message-Banner)  
or via the command line :
``` bash
$ git clone https://github.com/Loadex/Message-Banner.git
```
Drag the ```Message Banner``` folder into your project.

Quick Start Guide
----------------


Add the import to the top of classes that will use it. :
```objective-c
#import <MBLMessageBanner.h>
```

To show a basic notification use one of the following call :
```objective-c
[MBLMessageBanner showMessageBannerInViewController:aViewController
		                                   title:@"aTitle"
       		                            subtitle:@"aSubtitle"];

// ------------------------- OR -------------------------

    [MBLMessageBanner showMessageBannerInViewController:self
                                               title:@"aTitle"
                                            subtitle:@"aSubtitle"
                                               image:[UIImage imageNamed:@"icon.png"]
                                                type:MBLMessageBannerTypeMessage
                                            duration:MBLMessageBannerDurationDefault
                              userDissmissedCallback:^(MBLMessageBannerView *bannerView) {
                                  return;
                              }
                                         buttonTitle:@"BtnTitile"
                           userPressedButtonCallback:^(MBLMessageBannerView *banner) {
                                  return;
                              }
                                          atPosition:MBLMessageBannerPositionTop
                                canBeDismissedByUser:YES delegate:self];

```

Class documentation
----------------
###MBLMessageBanner class documentation
The **MBLMessageBanner class** provide the following methods

```objective-c
+ (void)setDefaultViewController:(UIViewController *)aViewController;
```  
Allow you to set a default view controller where the banners will be attached.  
**Default value** : UIApplication sharedApplication].keyWindow.rootViewController

```objective-c
+ (void)setMessageBannerDelegate:(id<MBLMessageBannerDelegate>)aDelegate;
```  
Allow to set the delegate of MBLMessageBanner class  
**See delegate documentation**

```objective-c
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                               atPosition:(MBLMessageBannerPosition)messagePosition;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MBLMessageBannerType)type
                               atPosition:(MBLMessageBannerPosition)messagePosition;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                               atPosition:(MBLMessageBannerPosition)messagePosition;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MBLMessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MBLMessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                    image:(UIImage *)image
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MBLMessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MBLMessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                   image:(UIImage *)image
                                    type:(MBLMessageBannerType)type
                                duration:(NSTimeInterval)duration
                                userDissmissedCallback:(void (^)(MBLMessageBannerView* bannerView))userDissmissedCallback
                             buttonTitle:(NSString *)buttonTitle
                          userPressedButtonCallback:(void (^)(MBLMessageBannerView* banner))userPressedButtonCallback
                              atPosition:(MBLMessageBannerPosition)messagePosition
                    canBeDismissedByUser:(BOOL)dismissingEnabled
                                 delegate:(id <MBLMessageBannerDelegate>)aDelegate;


+ (void)showMessageBanner:(MBLMessageBannerView *)messageBannerView;
```
Add a new MBLMessageBannerView to be displayed. Each MBLMessageBannerView is shown on the screen alone. If multiple calls, the MBLMessageBanner will show it when the previous message banner views disappeared.  
**Parameters description**  
* **viewController**: The view controller to show the message banner in. Can also be a UINavigationController. If nil, will use the default view controller instead.
* **title**: The title in the message banner view.
* **subtitle**: The subtitle in the message banner view.
* **image**: The left image showed in the message banner view.
* **type**: The message banner view type (See type section for available values). The message type allow to load the correct design in the design configuration file. (See configuration file section)
* **duration**: The message banner displaying duration in seconds. (See duration section for custom values)
* **userDissmissedCallback**: The block that should be executed when a user dismiss a message banner. (see dismiss gestures section to see possible dismiss gestures)
* **buttonTittle**: The title of the button. If set will allow a button to be created otherwise the message banner won't have a button.
* **userPressedButtonCallback**: The block that should be executed when a user hit the button if not nil.
* **messagePosition**: The message position on the viewController. (see position section to see possible positions)
* **dismissingEnabled**: Enable or disable the user dismissing methods on the message banner view.
* **aDelegate**: Set the delegate of the message banner (See delegate documentation to see available delegate methods)
* **messageBannerView**: An existing instance of a MessageBannerView to show next or instantly in not any are showed.

```objective-c
+ (BOOL) hideMessageBanner;
+ (BOOL) hideMessageBannerWithCompletion:(void (^)())completion;
```
Hide the currently displayed message banner  
**Parameters description**
* **completion**: The block that should be executed when the message banner is hidden.  
**Return value**
* **BOOL**: Return YES if a message banner has been dismissed, NO otherwise.

###MBLMessageBannerView class documentation
The **MBLMessageBannerView** class provide the following methods:  
```objective-c
+ (BOOL)addMessageBannerDesignFromFileNamed:(NSString *)file;
```
Load a custom message banner design file.  
**Parameters description**  
* **file**:The name of the JSON config file. (See design configuration file section for syntax)  
**Return value**: YES if the file is corretly loaded. NO otherwise.

Delegate methods
----------------
The message banner class implements a delegate protocol with the following **optional** methods:
```objective-c
- (void)messageBannerViewWillAppear:(MBLMessageBannerView *)messageBanner;
- (void)messageBannerViewDidAppear:(MBLMessageBannerView *)messageBanner;
- (void)messageBannerViewWillDisappear:(MBLMessageBannerView *)messageBanner;
- (void)messageBannerViewDidDisappear:(MBLMessageBannerView *)messageBanner;
```
**Parameters description**
* messageBanner The message banner about to be displayed/hidden

NSNotifications
----------------
The MBLMessageBanner class also send signals when the message banner is about or did appear/disappear. Each notification is directly **sent by the MBLMessageBannerView**.
The signals sent are:


|Description                               |Notification name                         |Notification define                            |
|:----------------------------------------:|:----------------------------------------:|:---------------------------------------------:|
|Sent when the view is about to appear.    |messageBannerViewWillAppearNotification   |MESSAGE_BANNER_VIEW_WILL_APPEAR_NOTIFICATION   |
|Sent when the view is about to appear.    |messageBannerViewDidAppearNotification    |MESSAGE_BANNER_VIEW_DID_APPEAR_NOTIFICATION    |
|Sent when the view is about to disappear. |messageBannerViewWillDisappearNotification|MESSAGE_BANNER_VIEW_WILL_DISAPPEAR_NOTIFICATION|
|Sent when the view is about to disappear. |messageBannerViewDidDisappearNotification |MESSAGE_BANNER_VIEW_DID_DISAPPEAR_NOTIFICATION |

Message Positions
-----------------
Each Message Banner View has a position. By default or if not set, the message banner view will have the position defined by **MBLMessageBannerPositionTop**
Available positions are:
* **MBLMessageBannerPositionTop**: The message banner will be displayed on the top of the view controller, right under the status bar or the navigation controller if the view has one.
* **MBLMessageBannerPositionCenter**: The message banner will be displayed on the middle of the view controller.
* **MBLMessageBannerPositionBottom**: The message banner will be displayed on the bottom of the view controller, or just above the toolbar if the view has one.  
![Top Positionning](/Screenshots/MessageBannerTopPosition.png?raw=true "Top positioned message banner")
![Center Positioning](/Screenshots/MessageBannerMiddlePosition.png?raw=true "Centered message banner")
![Bottom Positioning](/Screenshots/MessageBannerBottomPosition.png?raw=true "Bottom positioned message banner")

Message types
----------------
Each Message Banner is defined by his type. The desig in the config file is loaded according to the his type.
Available type with their already setted design are :
* **MBLMessageBannerTypeError**: The error message banner.
* **MBLMessageBannerTypeWarning**: The warning message banner.
* **MBLMessageBannerTypeMessage**: The standart message banner.
* **MBLMessageBannerTypeSuccess**: The success message banner.  
![Message Error](/Screenshots/MessageBannerErrorType.png?raw=true "Error message banner")
![Message Warning](/Screenshots/MessageBannerWarningType.png?raw=true "Warning message banner")
![Message](/Screenshots/MessageBannerMessageType.png?raw=true "Message message banner")
![Message Success](/Screenshots/MessageBannerSuccessType.png?raw=true "Success message banner")

Message duration
----------------
Each Message Banner has a "stay on screen" time. This duration can be manually setted by the method parameter. However, the class also provide custom durations :
* **MBLMessageBannerDurationDefault**: The duration will be automatically calculated according to the size of the message banner view.
* **MBLMessageBannerDurationEndless**: The message banner will be displayed until the user dismiss it or it is dismissed programatically.

Dismiss methods
----------------
The message banner can be dismissed with multiple user gesture. The user can dismiss it with a **single tap** on the view and swipes gesture. The swipes dismiss gesture are different according to the position of the banner.
* **MBLMessageBannerPositionTop**: The user can **swipe to the top** of the screen to dismiss the banner.
* **MBLMessageBannerPositionCenter**: The user can **swipe both to the left and right** to dismiss the banner.
* **MBLMessageBannerPositionBottom**: The user can **swipe to the bottom** of the screen to dismiss the banner.

Design configuration file
----------------
The configuration file is a JSON formated file.

The JSON file is formatted this way :

```JSON
{
    "MessageBannerTypeName": {
        "PropertyName"    : "Property value"
        ,"AnotherProperty" : 1.0
    },

    "AnOtherMessageBannerTypeName": {
        "PropertyName"    : "Property value"
        ,"AnotherProperty" : 1.0
    }
}
```

This library come with 4 differents type of banner, with the following corresponding name for the JSON design file format :

|   Name   |   Type   |
|:--------:|:--------:|
|Error     |MBLMessageBannerTypeError|
|Warning   |MBLMessageBannerTypeWarning|
|Message   |MBLMessageBannerTypeMessage|
|Success   |MBLMessageBannerTypeSuccess|

Each type of banner can have the following properties :

### General properties
|     Property name     |                    Effect                   |    Possible values   |   Default value    |                Remarks                    |
|:---------------------:|---------------------------------------------|:--------------------:|:------------------:|-------------------------------------------|
|defaultImageForType    | Define a default left image                 | "The_image_name.png" |         None       |The image parameter override this setting  |
|blurRadius             | Blur the attached view with the given radius|         0.0+         |   0.0 (Disabled)   | iOS7 style default radius for blur is 40.0|
|backgroundColor        | Set the banner background color             |      "#FFFFFF"       | "#FFFFFF" (White)  | BackgroundImageName override this parameter|
|backgroundImageName    | Set the banner background image             | "The_image_name.png" |        None        | Override BackgroundColor property         |
|backgroundAlpha        | Set the banner background color transparency|     0.0 -> 1.0       |        1.0         |                                           |

### Title properties
|     Property name     |                    Effect                   |    Possible values   |   Default value    |                Remarks                    |
|:---------------------:|---------------------------------------------|:--------------------:|:------------------:|-------------------------------------------|
|titleTextColor         | Set the banner title text color             |     "#FFFFFF"        | "#000000" (Black)  |                                           |
|titleTextSize          | Set the banner title text size              | 0.0+                 |        14.0        |                                           |
|titleTextShadowColor   | Set the banner title text shadow color      | "#FFFFFF"            | "#FFFFFF" (White)  |                                           |
|titleTextShadowAlpha   | Set the banner title text shadow transparency| 0.0 -> 1.0          |        1.0         |                                           |
|titleTextShadowOffsetX | Set the banner title text x shadow offset   |      -0.0+           |         0.0        |                                           |
|titleTextShadowOffsetY | Set the banner title text y shadow offset   |      -0.0+           |         1.0        |                                           |

### Subtitle properties
|     Property name     |                    Effect                   |    Possible values   |   Default value    |                Remarks                    |
|:---------------------:|---------------------------------------------|:--------------------:|:------------------:|-------------------------------------------|
|subtitleTextColor         | Set the banner subtitle text color             |     "#FFFFFF"        | "#000000" (Black)  |                                           |
|subtitleTextSize          | Set the banner subtitle text size              | 0.0+                 |        14.0        |                                           |
|subtitleTextShadowColor   | Set the banner subtitle text shadow color      | "#FFFFFF"            | "#FFFFFF" (White)  |                                           |
|subtitleTextShadowAlpha   | Set the banner subtitle text shadow transparency| 0.0 -> 1.0          |        1.0         |                                           |
|subtitleTextShadowOffsetX | Set the banner subtitle text x shadow offset   |      -0.0+           |         0.0        |                                           |
|subtitleTextShadowOffsetY | Set the banner subtitle text y shadow offset   |      -0.0+           |         1.0        |                                           |

### Button properties
|     Property name     |                    Effect                   |    Possible values   |   Default value    |                Remarks                    |
|:---------------------:|---------------------------------------------|:--------------------:|:------------------:|-------------------------------------------|
|buttonBackgroundColor  | Set the button background color             | "#FFFFFF"            |  "#FFFFFF" (White) | buttonBackgroundImage and buttonBackgroundPatternImage override this parameter|
|buttonBackgroundImage  | Set the button background image               |  "The_image_name.png"|        None        | Ovveride buttonBackgroundColor            |
|buttonBackgroundPatternImage  | Set the button background image with a pattern image |  "The_image_name.png"|        None        | Ovveride buttonBackgroundImage            |
|buttonBackgroundAlpha  | Set the button background transparency      |  0.0 -> 1.0          |        1.0         |                                           |
|buttonCornerRadius     | Set the button corner radius                |       0.0+           |        0.0         |                                           |
|buttonBorderColor      | Set the button border color                 | "#FFFFFF"            |  "#000000"(Black)  | Visible only if buttonBorderSize >= 1     |
|buttonBorderAlpha      | Set the button border transparency          | 0.0 -> 1.0           |       1.0          |                                           |
|buttonBorderSize       | Set the border size of the button           | 0.0+                 |      0.0 (None)    |                                           |
|buttonTextColor         | Set the banner button text color             |     "#FFFFFF"        | "#000000" (Black)  |                                           |
|buttonTextSize          | Set the banner button text size              | 0.0+                 |        14.0        |                                           |
|buttonTextShadowColor   | Set the banner button text shadow color      | "#FFFFFF"            | "#FFFFFF" (White)  |                                           |
|buttonTextShadowAlpha   | Set the banner button text shadow transparency| 0.0 -> 1.0          |        1.0         |                                           |
|buttonTextShadowOffsetX | Set the banner button text x shadow offset   |      -0.0+           |         0.0        |                                           |
|buttonTextShadowOffsetY | Set the banner button text y shadow offset   |      -0.0+           |         1.0        |                                           |

Roadmap
----------------
####Current Version : ***1.0.3***  

- ***V1.0:***  
	+ Eventual bug fixes
	+ Finish Readme.md documentation
	+ Fix incorrect project organisation
	+ Create Pod Module

- ***V1.1:***
	+ Create JSON View Behavior Config File
		- Create Config for custom dismiss methods
		- Create config for custom animation times
		- Create config for custom stay in screen time automatic mode calculation
		- Add default image enabled or not  

- ***V1.2:***
	+ Create Manager JSON config File
		- Create config for multipopups (then to move in behavior cfg to separate for each type)
		- Create config to add “shadow” or “blur” on given View Controller (Or view on screen if its a navigation controller)
		- Create config to allow or not user interaction on the presented view (then to move in behavior cfg to separate for each type)
		- Create Auto depop when screen change var
- ***V1.3:***
	- Add auto-Banner for Network problem + config

- ***V2.0:***
	- Create Swift Version

FAQ
----------------
No question asked so far.

Requirements
----------------
This project require :
+ ```iOS7```
+ ```ARC```

Licence
----------------
MIT Licence  
Copyright (c) 2014 Thibault Carpentier <carpen_t@epitech.eu>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


Repository Infos
----------------

    Owner:      Thibault Carpentier
    GitHub:     https://github.com/Loadex
    LinkedIn:   www.linkedin.com/in/CarpentierThibault/
    StackOverflow:  http://stackoverflow.com/users/1324369/loadex
