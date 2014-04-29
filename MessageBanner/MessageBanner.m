//
//  MessageBanner.m
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import "MessageBanner.h"
#import "MessageBannerView.h"

@implementation MessageBanner

@synthesize notificationsList;

#define ANIMATION_DURATION 2.0

static MessageBanner *sharedSingleton;

+ (MessageBanner *)sharedSingleton
{
    if (!sharedSingleton)
    {
        sharedSingleton = [[[self class] alloc] init];
    }
    return sharedSingleton;
}

-(id)init {
    if ((self = [super init])) {
        notificationsList = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                   image:(UIImage *)image
                                    type:(MessageBannerType)type
                                duration:(NSTimeInterval)duration
                                callback:(void (^)())callback
                             buttonTitle:(NSString *)buttonTitle
                          buttonCallback:(void (^)())buttonCallback
                              atPosition:(MessageBannerPosition)messagePosition
                    canBeDismissedByUser:(BOOL)dismissingEnabled {
    

    MessageBannerView *view = [[MessageBannerView alloc] initWithTitle:title subtitle:subtitle image:image type:MessageBannerNotificationTypeMessage duration:duration inViewController:viewController callback:callback buttonTitle:buttonTitle buttonCallback:buttonCallback atPosition:messagePosition canBeDismissedByUser:dismissingEnabled];
    
    [self prepareNotification:view];
}

+ (void)prepareNotification:(MessageBannerView *)notificationView {

    NSString *title = notificationView.title;
    NSString *subtitle = notificationView.subTitle;
    
    for (MessageBannerView *n in [MessageBanner sharedSingleton].notificationsList)
    {
        if (([n.title isEqualToString:title] || (!n.title && !title)) && ([n.subTitle isEqualToString:subtitle] || (!n.subTitle && !subtitle)))
        {
            return; // avoid showing the same messages twice in a row
        }
    }
    
    [[MessageBanner sharedSingleton].notificationsList addObject:notificationView];
    [self showNotification];
}

+ (void)showNotification {
    
    if (![[MessageBanner sharedSingleton].notificationsList count]) {
        NSLog(@"No notification to show");
        return;
    }
    
    MessageBannerView *currentNotification = [[MessageBanner sharedSingleton].notificationsList firstObject];
    
    CGPoint target = CGPointMake(currentNotification.viewController.view.center.x, currentNotification.viewController.view.center.y);
    
//    currentNotification.frame = CGRectMake(0, 0, 150, 150);
//    currentNotification.backgroundColor = [UIColor redColor];
    [currentNotification.viewController.view addSubview:currentNotification];
    
    [UIView animateKeyframesWithDuration:ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
#warning to correctly set.
        currentNotification.center = target;
        currentNotification.backgroundColor = [UIColor yellowColor];
        
    } completion:^(BOOL finished) {
        
        NSLog(@"DONE");
        
    }];
    
    [[MessageBanner sharedSingleton].notificationsList removeObjectAtIndex:0];
}

@end
