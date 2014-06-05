/**
 * @file   MessageBanneviewr.h
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MessageBannerView popup flat styled view.
 *
 * MessageBannerView a customisable popupview
 */

#import <UIKit/UIKit.h>
#import "MessageBanner.h"

@interface MessageBannerView : UIView

/**
 The banner title
 */
@property (nonatomic, readonly, copy)   NSString*               titleBanner;
/**
 The banner subtitle
 */
@property (nonatomic, readonly, copy)   NSString*               subTitle;
/**
 The banner left image
 */
@property (nonatomic, readonly, copy)   UIImage*                image;
/**
 The type of the banner
 */
@property (nonatomic, readonly, assign) MessageBannerType       bannerType;
/**
 The banner setted duration
 */
@property (nonatomic, readonly, assign) CGFloat                 duration;
/**
 The viewController to attach the banner on
 */
@property (nonatomic, readonly)         UIViewController*       viewController;
/**
 The callback called when the user dismiss the popup
 */
@property (nonatomic, readonly, copy)   void (^userDissmissedCallback)(MessageBannerView* banner);
/**
 The right button title
 */
@property (nonatomic, readonly, copy)   NSString*               buttonTitle;
/**
 The button callback
 */
@property (nonatomic, readonly, copy)   void (^userPressedButtonCallback)(MessageBannerView* banner);
/**
 The banner position
 */
@property (nonatomic, readonly, assign) MessageBannerPosition   position;
/**
 Determine if a user can dismiss or no a banner
 */
@property (nonatomic, readonly, assign) BOOL                    userDismissEnabled;
/**
 The timer of the banner
 */
@property (nonatomic, strong)           NSTimer*                dismissTimer;
/**
 Actual display state of the banner
 */
@property (nonatomic, assign)           BOOL                    isBannerDisplayed;
/**
 The banner design dictionnary
 */
@property (nonatomic, readonly, copy)   NSDictionary            *currentDesign;

/**
 Create a message banner

 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param image The image to show on the left of the message banner
 @param type The type of the message banner @see MessageBannerType values
 @param duration The popup duration on screen @see MessageBannerDuration for specials durations
 @param viewController The view where the message banner will be added
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param buttonTitle Enable a button on the right of the view created with this title
 @param userPressedButtonCallback A callback when the user press the button
 @param messagePosition The position of the message banner @see MessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 */
- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              image:(UIImage *)image
               type:(MessageBannerType)bannerType
           duration:(CGFloat)duration
   inViewController:(UIViewController *)viewController
           userDissmissedCallback:(void (^)(MessageBannerView* banner))callback
        buttonTitle:(NSString *)buttonTitle
     userPressedButtonCallback:(void (^)(MessageBannerView *banner))userPressedButtonCallback
         atPosition:(MessageBannerPosition)position
canBeDismissedByUser:(BOOL)dismissingEnabled;

@end
