/**
 * @file   MessageBanneviewr.h
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MBLMessageBannerView popup flat styled view.
 *
 * MBLMessageBannerView a customisable popupview
 */

#import <UIKit/UIKit.h>
#import "MBLMessageBanner.h"

@interface MBLMessageBannerView : UIView

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
@property (nonatomic, readonly, assign) MBLMessageBannerType       bannerType;
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
@property (nonatomic, readonly, copy)   void (^userDissmissedCallback)(MBLMessageBannerView* banner);
/**
 The right button title
 */
@property (nonatomic, readonly, copy)   NSString*               buttonTitle;
/**
 The button callback
 */
@property (nonatomic, readonly, copy)   void (^userPressedButtonCallback)(MBLMessageBannerView* banner);
/**
 The banner position
 */
@property (nonatomic, readonly, assign) MBLMessageBannerPosition   position;
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
 The message view height used for calculs
 */
@property (nonatomic, readonly, assign) CGFloat  messageViewHeight;

/**
 Create a message banner

 @param title The title of the message banner
 @param subtitle The subtitle of the message banner
 @param image The image to show on the left of the message banner
 @param type The type of the message banner @see MBLMessageBannerType values
 @param duration The popup duration on screen @see MBLMessageBannerDuration for specials durations
 @param viewController The view where the message banner will be added
 @param userDissmissedCallback A callback when the user dismiss the popup
 @param buttonTitle Enable a button on the right of the view created with this title
 @param userPressedButtonCallback A callback when the user press the button
 @param messagePosition The position of the message banner @see MBLMessageBannerPosition values
 @param dismissingEnabled Enable/Disable user dismiss on the message banner
 */
- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              image:(UIImage *)image
               type:(MBLMessageBannerType)bannerType
           duration:(CGFloat)duration
   inViewController:(UIViewController *)viewController
           userDissmissedCallback:(void (^)(MBLMessageBannerView* banner))callback
        buttonTitle:(NSString *)buttonTitle
     userPressedButtonCallback:(void (^)(MBLMessageBannerView *banner))userPressedButtonCallback
         atPosition:(MBLMessageBannerPosition)position
canBeDismissedByUser:(BOOL)dismissingEnabled;

/**
 Load a custom design file
 @param file the new design file
 @returns value YES if the new file is loaded, NO otherwise.
 */
+ (BOOL)addMessageBannerDesignFromFileNamed:(NSString *)file;
/**
 Return the currently set design file.
 @returns the current design file.
 */
+ (NSMutableDictionary *)messageBannerDesign;

/**
 Set the default design file.
 @returns void
 */
+ (void)setDefaultDesignFile:(NSString *)fileName;

@end