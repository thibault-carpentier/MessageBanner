/**
 * @file   MBLMessageBanner.h
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MBLMessageBannerView manager.
 *
 * MBLMessageBanner allow to easilly manage popups.
 */


#import <Foundation/Foundation.h>

/**
 Message banner notification sended when the messagebanner will appear
 */
#define MESSAGE_BANNER_VIEW_WILL_APPEAR_NOTIFICATION @"MBLMessageBannerViewWillAppearNotification"
/**
 Message banner notification sended when the messagebanner did appear
 */
#define MESSAGE_BANNER_VIEW_DID_APPEAR_NOTIFICATION @"MBLMessageBannerViewDidAppearNotification"
/**
 Message banner notification sended when the messagebanner will disappear
 */
#define MESSAGE_BANNER_VIEW_WILL_DISAPPEAR_NOTIFICATION @"MBLMessageBannerViewWillDisappearNotification"
/**
 Message banner notification sended when the messagebanner did disappear
 */
#define MESSAGE_BANNER_VIEW_DID_DISAPPEAR_NOTIFICATION @"MBLMessageBannerViewDidDisappearNotification"


// Forward declaration to avoid double includes problems
@class MBLMessageBannerView;

/**
 An enumeration of MBLMessageBannerView types
 */
typedef NS_ENUM(NSInteger, MBLMessageBannerType) {
      MBLMessageBannerTypeError    = 0 /** A message banner used to show errors   */
    , MBLMessageBannerTypeWarning  = 1 /** A message banner used to show warnings */
    , MBLMessageBannerTypeMessage  = 2 /** A message banner used to show message  */
    , MBLMessageBannerTypeSuccess  = 3 /** A message banner used to show success  */
};
/**
 An enumeration of MBLMessageBannerView positions
 */
typedef NS_ENUM(NSInteger, MBLMessageBannerPosition) {
      MBLMessageBannerPositionTop    = 0 /** A top positioned message banner      */
    , MBLMessageBannerPositionCenter = 1 /** A centered positioned message banner */
    , MBLMessageBannerPositionBottom = 2 /** A bottom positioned message banner   */
};
/**
 An enumeration of custom message banner duration
 */
typedef NS_ENUM(NSInteger, MBLMessageBannerDuration) {
      MBLMessageBannerDurationDefault = 0  /** A duration calculated automatically */
    , MBLMessageBannerDurationEndless = -1 /** An endless duration                 */
};


/**
 Set of methods to implement to be notified on appearance/disappearance of message banners
 */
@protocol MBLMessageBannerDelegate <NSObject>
@optional
/**
 A message Banner view will appear
 @param MessageBanner the message banner about to appear
 */
- (void)messageBannerViewWillAppear:(MBLMessageBannerView *)messageBanner;
/**
 A message Banner view did appear
 @param MessageBanner the message banner which appeared
 */
- (void)messageBannerViewDidAppear:(MBLMessageBannerView *)messageBanner;
/**
 A message Banner view will disappear
 @param messageBanner the message banner about to disappear
 */
- (void)messageBannerViewWillDisappear:(MBLMessageBannerView *)messageBanner;
/**
 A message Banner view did disappear
 @param messageBanner the message banner which disappeared
 */
- (void)messageBannerViewDidDisappear:(MBLMessageBannerView *)messageBanner;
@end


/**
 A message banner manager class
 */
@interface MBLMessageBanner : NSObject

/**
 Returns the shared instance of the manager
 @returns manager shared instance
 */
+ (instancetype) sharedSingleton;
/**
 Return the defaultViewController
 @return The default view controller
 */
+ (UIViewController *)defaultViewController;
/**
 Set the default view controller
 @param aViewController the new default view controller
 */
+ (void)setDefaultViewController:(UIViewController *)aViewController;
#pragma mark - Set Delegate

/**
 Set MessageBanner delegate
 @param aDelegate the new message banner Delegate
 */
+ (void)setMessageBannerDelegate:(id<MBLMessageBannerDelegate>)aDelegate;

#pragma mark - Show Methods

/**
 Show a message banner
 @param messageView The message banner view to show
 @param viewController The view where the message banner will be added
 */
+ (void)showMessageBanner:(MBLMessageBannerView*)messageView;

/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param messagePosition The position of the message banner @see MessageBannerPosition values
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                               atPosition:(MBLMessageBannerPosition)messagePosition;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param type The type of the message banner @see MessageBannerType values
 @param messagePosition The position of the message banner @see MessageBannerPosition values
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MBLMessageBannerType)type
                               atPosition:(MBLMessageBannerPosition)messagePosition;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param type The type of the message banner @see MBLMessageBannerType values
 @param duration The popup duration on screen @see MBLMessageBannerDuration for specials durations
 @param messagePosition The position of the message banner @see MBLMessageBannerPosition values
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                               atPosition:(MBLMessageBannerPosition)messagePosition;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param type The type of the message banner @see MBLMessageBannerType values
 @param duration The popup duration on screen @see MBLMessageBannerDuration for specials durations
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param messagePosition The position of the message banner @see MBLMessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MBLMessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MBLMessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param image The image to show on the left of the message banner
 @param type The type of the message banner @see MBLMessageBannerType values
 @param duration The popup duration on screen @see MBLMessageBannerDuration for specials durations
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param messagePosition The position of the message banner @see MBLMessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                    image:(UIImage *)image
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MBLMessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MBLMessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param image The image to show on the left of the message banner
 @param type The type of the message banner @see MBLMessageBannerType values
 @param duration The popup duration on screen @see MBLMessageBannerDuration for specials durations
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param buttonTitle Enable a button on the right of the view created with this title
 @param userPressedButtonCallback A callback when the user press the button
 @param messagePosition The position of the message banner @see MBLMessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 @param aDelegate Set the class delegate if not setted yet
 */
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

#pragma mark - Hide Methods
/**
 Hide the current message banner on screen
 @returns the success of the operation
 @retval NO If there is no message banner to hide
 @retval YES If a message banner has been hiden
 */
+ (BOOL) hideMessageBanner;
/**
 Hide the current message banner on screen
 @param completion A callback when the message banner is hidden
 @returns the success of the operation
 @retval NO if there is no message banner to hide
 @retval YES if a message banner has been hiden
 */
+ (BOOL) hideMessageBannerWithCompletion:(void (^)())completion;

@end
