/**
 * @file   MessageBanner.h
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MessageBannerView manager.
 *
 * MessageBanner allow to easilly manage popups.
 */


#import <Foundation/Foundation.h>

/**
 Message banner notification sended when the messagebanner will appear
 */
#define MESSAGE_BANNER_VIEW_WILL_APPEAR_NOTIFICATION @"messageBannerViewWillAppearNotification"
/**
 Message banner notification sended when the messagebanner did appear
 */
#define MESSAGE_BANNER_VIEW_DID_APPEAR_NOTIFICATION @"messageBannerViewDidAppearNotification"
/**
 Message banner notification sended when the messagebanner will disappear
 */
#define MESSAGE_BANNER_VIEW_WILL_DISAPPEAR_NOTIFICATION @"messageBannerViewWillDisappearNotification"
/**
 Message banner notification sended when the messagebanner did disappear
 */
#define MESSAGE_BANNER_VIEW_DID_DISAPPEAR_NOTIFICATION @"messageBannerViewDidDisappearNotification"


// Forward declaration to avoid double includes problems
@class MessageBannerView;

/**
 An enumeration of MessageBannerView types
 */
typedef NS_ENUM(NSInteger, MessageBannerType) {
      MessageBannerTypeError    = 0 /** A message banner used to show errors   */
    , MessageBannerTypeWarning  = 1 /** A message banner used to show warnings */
    , MessageBannerTypeMessage  = 2 /** A message banner used to show message  */
    , MessageBannerTypeSuccess  = 3 /** A message banner used to show success  */
};
/**
 An enumeration of MessageBannerView positions
 */
typedef NS_ENUM(NSInteger, MessageBannerPosition) {
      MessageBannerPositionTop    = 0 /** A top positioned message banner      */
    , MessageBannerPositionCenter = 1 /** A centered positioned message banner */
    , MessageBannerPositionBottom = 2 /** A bottom positioned message banner   */
};
/**
 An enumeration of custom message banner duration
 */
typedef NS_ENUM(NSInteger, MessageBannerDuration) {
      MessageBannerDurationDefault = 0  /** A duration calculated automatically */
    , MessageBannerDurationEndless = -1 /** An endless duration                 */
};


/**
 Set of methods to implement to be notified on appearance/disappearance of message banners
 */
@protocol MessageBannerDelegate <NSObject>
@optional
/**
 A message Banner view will appear
 @param messageBanner the message banner about to appear
 */
- (void)messageBannerViewWillAppear:(MessageBannerView *)messageBanner;
/**
 A message Banner view did appear
 @param messageBanner the message banner which appeared
 */
- (void)messageBannerViewDidAppear:(MessageBannerView *)messageBanner;
/**
 A message Banner view will disappear
 @param messageBanner the message banner about to disappear
 */
- (void)messageBannerViewWillDisappear:(MessageBannerView *)messageBanner;
/**
 A message Banner view did disappear
 @param messageBanner the message banner which disappeared
 */
- (void)messageBannerViewDidDisappear:(MessageBannerView *)messageBanner;
@end


/**
 A message banner manager class
 */
@interface MessageBanner : NSObject

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
+ (void)setMessageBannerDelegate:(id<MessageBannerDelegate>)aDelegate;

#pragma mark - Show Methods

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
                               atPosition:(MessageBannerPosition)messagePosition;
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
                                     type:(MessageBannerType)type
                               atPosition:(MessageBannerPosition)messagePosition;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param type The type of the message banner @see MessageBannerType values
 @param duration The popup duration on screen @see MessageBannerDuration for specials durations
 @param messagePosition The position of the message banner @see MessageBannerPosition values
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                               atPosition:(MessageBannerPosition)messagePosition;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param type The type of the message banner @see MessageBannerType values
 @param duration The popup duration on screen @see MessageBannerDuration for specials durations
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param messagePosition The position of the message banner @see MessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param image The image to show on the left of the message banner
 @param type The type of the message banner @see MessageBannerType values
 @param duration The popup duration on screen @see MessageBannerDuration for specials durations
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param messagePosition The position of the message banner @see MessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                    image:(UIImage *)image
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;
/**
 Show a message banner
 @param viewController The view where the message banner will be added
 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param image The image to show on the left of the message banner
 @param type The type of the message banner @see MessageBannerType values
 @param duration The popup duration on screen @see MessageBannerDuration for specials durations
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param buttonTitle Enable a button on the right of the view created with this title
 @param userPressedButtonCallback A callback when the user press the button
 @param messagePosition The position of the message banner @see MessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 @param aDelegate Set the class delegate if not setted yet
 */
+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                   image:(UIImage *)image
                                    type:(MessageBannerType)type
                                duration:(NSTimeInterval)duration
                                userDissmissedCallback:(void (^)(MessageBannerView* bannerView))userDissmissedCallback
                             buttonTitle:(NSString *)buttonTitle
                          userPressedButtonCallback:(void (^)(MessageBannerView* banner))userPressedButtonCallback
                              atPosition:(MessageBannerPosition)messagePosition
                    canBeDismissedByUser:(BOOL)dismissingEnabled
                                 delegate:(id <MessageBannerDelegate>)aDelegate;

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
