//
//  MessageBannerView.h
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBanner.h"

@interface MessageBannerView : UIView

@property (nonatomic, readonly, copy)   NSString*               titleBanner;
@property (nonatomic, readonly, copy)   NSString*               subTitle;
@property (nonatomic, readonly, copy)   UIImage*                image;
@property (nonatomic, readonly, assign) MessageBannerType       bannerType;
@property (nonatomic, readonly, assign) CGFloat                 duration;
@property (nonatomic, readonly)         UIViewController*       viewController;
@property (nonatomic, readonly, copy)   void (^userDissmissedCallback)(MessageBannerView* banner);

@property (nonatomic, readonly, copy)   NSString*               buttonTitle;
@property (nonatomic, readonly, copy)   void (^userPressedButtonCallback)(MessageBannerView* banner);

@property (nonatomic, readonly, assign) MessageBannerPosition   position;
@property (nonatomic, readonly, assign) BOOL                    userDismissEnabled;

@property (nonatomic, strong)           NSTimer*                dismissTimer;
@property (nonatomic, assign)           BOOL                    isBannerDisplayed;

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
