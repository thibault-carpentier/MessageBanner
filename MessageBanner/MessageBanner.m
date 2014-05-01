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

#pragma mark -
#pragma mark Init methods

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
            // Add some check in the config file if it allow multiple pop-ups
            return;
        }
    }
    [[MessageBanner sharedSingleton].notificationsList addObject:notificationView];
    [[MessageBanner sharedSingleton] showNotification];
}

#pragma mark -
#pragma mark Show notification methods

// To add later maybe ? 
- (CGFloat) getStatusBarSize {
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    CGFloat offset = isPortrait ? statusBarSize.height : statusBarSize.width;
    
    return (offset);
}

-(CGFloat)calculateTopOffset:(MessageBannerView *)message {
    CGFloat topOffset = 0.0f;
    
    // If has a navigationController
    if ([message.viewController isKindOfClass:[UINavigationController class]] || [message.viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        // Getting the current view Controller
        UINavigationController *currentNavigationController;
        if ([message.viewController isKindOfClass:[UINavigationController class]]) {
            currentNavigationController = (UINavigationController *)message.viewController;
        } else {
            currentNavigationController = (UINavigationController *)message.viewController.parentViewController;
        }
        
        // If the navigationBar is visible we add his height as an offset
        if (![currentNavigationController isNavigationBarHidden] &&
            ![[currentNavigationController navigationBar] isHidden]) {
            
            // Adding the view on the navcontroller
            [currentNavigationController.view insertSubview:message belowSubview:[currentNavigationController navigationBar]];
            
            topOffset += [currentNavigationController navigationBar].bounds.size.height;
        } else {
            [message.viewController.view addSubview:message];
        }
    } else {
        [message.viewController.view addSubview:message];
    }
    topOffset += [self getStatusBarSize];

    
    
    return topOffset;
}

- (CGPoint)calculateCenter:(MessageBannerView *)message {
    CGPoint result;
    
    switch (message.position) {
        case MessageBannerPositionTop:
            result = CGPointMake(  message.center.x
                                 , (message.frame.size.height / 2.0f) + [self calculateTopOffset:message]);
            break;
        case MessageBannerPositionBottom:
#warning TO DO
            break;
        case MessageBannerPositionCenter:
#warning  TO DO
            break;
        default:
            break;
    }
    return (result);
}

- (void)showNotification {
    
    if (![[MessageBanner sharedSingleton].notificationsList count]) {
        NSLog(@"No notification to show");
        return;
    }
    
    MessageBannerView *currentNotification = [[MessageBanner sharedSingleton].notificationsList firstObject];

    
    
    CGPoint target = [self calculateCenter:currentNotification];
    //CGPointMake(currentNotification.viewController.view.center.x, currentNotification.viewController.view.center.y);

//    [currentNotification.viewController.view addSubview:currentNotification];
    
    [UIView animateKeyframesWithDuration:ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
#warning to correctly set.
        currentNotification.center = target;
        currentNotification.backgroundColor = [UIColor yellowColor];
        
    } completion:^(BOOL finished) {
        
        NSLog(@"DONE");
        
    }];
    
    [[MessageBanner sharedSingleton].notificationsList removeObjectAtIndex:0];
}

#pragma mark -
#pragma mark Hide notification nethods

@end
