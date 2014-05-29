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

@property (nonatomic, assign) BOOL                    isDisplayed;

@property (nonatomic, readonly) NSString*             title;
@property (nonatomic, readonly) NSString*             subTitle;
@property (nonatomic, readonly) UIViewController*     viewController;

@property (nonatomic, assign)   CGFloat               duration;
@property (nonatomic, strong)   NSTimer*              onScreenTimer;

@property (nonatomic, assign)   MessageBannerPosition position;
@property (nonatomic, copy)     UIImage*              image;

// View items

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              image:(UIImage *)image
               type:(MessageBannerType)notificationType
           duration:(CGFloat)duration
   inViewController:(UIViewController *)viewController
           callback:(void (^)())callback
        buttonTitle:(NSString *)buttonTitle
     buttonCallback:(void (^)())buttonCallback
         atPosition:(MessageBannerPosition)position
canBeDismissedByUser:(BOOL)dismissingEnabled;

@end
