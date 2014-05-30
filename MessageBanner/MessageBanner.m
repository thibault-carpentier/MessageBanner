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


#define ANIMATION_DURATION 0.5
#define DISPLAY_TIME_PER_PIXEL 0.02
#define DISPLAY_DEFAULT_DURATION 2.0

static MessageBanner *sharedSingleton;

+ (MessageBanner *)sharedSingleton
{
    if (!sharedSingleton)
    {
        sharedSingleton = [[[self class] alloc] init];
    }
    return sharedSingleton;
}

- (id)init {
    if ((self = [super init])) {
        _messagesBannersList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Init methods

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                   image:(UIImage *)image
                                    type:(MessageBannerType)type
                                duration:(NSTimeInterval)duration
                                userDissmissedCallback:(void (^)(MessageBannerView *bannerView))userDissmissedCallback
                             buttonTitle:(NSString *)buttonTitle
                          userPressedButtonCallback:(void (^)(MessageBannerView* banner))userPressedButtonCallback
                              atPosition:(MessageBannerPosition)messagePosition
                    canBeDismissedByUser:(BOOL)dismissingEnabled {
    
    
    MessageBannerView *view = [[MessageBannerView alloc] initWithTitle:title subtitle:subtitle image:image type:type duration:duration inViewController:viewController userDissmissedCallback:userDissmissedCallback buttonTitle:buttonTitle userPressedButtonCallback:userPressedButtonCallback atPosition:messagePosition canBeDismissedByUser:dismissingEnabled];
    [self prepareMessageBanner:view];
}

+ (void)prepareMessageBanner:(MessageBannerView *)messageBannerView {

#warning remove after testing
    
    //    NSString *title = messageBannerView.title;
    //    NSString *subtitle = messageBannerView.subTitle;
    //    for (MessageBannerView *n in [MessageBanner sharedSingleton].messagesBannersList)
    //    {
    //        if (([n.title isEqualToString:title] || (!n.title && !title)) && ([n.subTitle isEqualToString:subtitle] || (!n.subTitle && !subtitle)))
    //        {
    //            // Add some check in the config file later if it allow multiple pop-ups
    //            return;
    //        }
    //    }
    
    [[MessageBanner sharedSingleton].messagesBannersList addObject:messageBannerView];
    
    if ([[MessageBanner sharedSingleton] messageOnScreen] == NO) {
        [[MessageBanner sharedSingleton] showMessageBannerOnScreen];
    }
}

#pragma mark -
#pragma mark Show Message Banner methods

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

-(CGFloat)calculateBottomOffset:(MessageBannerView *)message {
    CGFloat bottomOffset = 0.0f;
    
    if (message.viewController.navigationController.isToolbarHidden == NO) {
        bottomOffset = (message.viewController.navigationController.toolbar.frame.size.height);
    }
    return bottomOffset;
}

- (CGPoint)calculateTargetCenter:(MessageBannerView *)message {
    CGPoint result;
    
    switch (message.position) {
        case MessageBannerPositionTop:
            result = CGPointMake(  message.center.x
                                 , (message.frame.size.height / 2.0f) + [self calculateTopOffset:message]);
            break;
        case MessageBannerPositionBottom:
            
            // Adding the popup to the view
            [message.viewController.view addSubview:message];
            result = CGPointMake( message.center.x, message.viewController.view.frame.size.height - ((message.frame.size.height / 2.0f) + [self calculateBottomOffset:message]));
            break;
        case MessageBannerPositionCenter:
            
            // Adding the popup to the view
            [message.viewController.view addSubview:message];
            
            result = CGPointMake(  message.viewController.view.center.x
                                 , message.center.y);
            break;
        default:
            break;
    }
    return (result);
}

- (void)showMessageBannerOnScreen {
    
    _messageOnScreen = YES;
    
    if (![[MessageBanner sharedSingleton].messagesBannersList count]) {
        NSLog(@"No Message Banner to show");
        return;
    }
    
    MessageBannerView *currentMessageBanner = [[MessageBanner sharedSingleton].messagesBannersList firstObject];
    
    CGPoint target = [self calculateTargetCenter:currentMessageBanner];
    [UIView animateKeyframesWithDuration:ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        currentMessageBanner.center = target;
        
    } completion:^(BOOL finished) {
        currentMessageBanner.isBannerDisplayed = YES;
    }];
    
    [self initAutoDismissTimerforBanner:currentMessageBanner];
}

#pragma mark -
#pragma mark Hide Message Banner methods

+ (void) hideMessageBanner:(MessageBannerView *)message withGesture:(UIGestureRecognizer *)gesture {
    
    //    Removing timer Callback
    message.isBannerDisplayed = NO;
    if (message.duration != MessageBannerDurationEndless) {
        [message.dismissTimer invalidate];
    }
    
    CGPoint fadeOutCenter = CGPointMake(0, 0);
    
    switch (message.position) {
        case MessageBannerPositionTop:
            fadeOutCenter = CGPointMake(  message.center.x
                                        , -(message.frame.size.height / 2.0f) );
            break;
        case MessageBannerPositionBottom:
            fadeOutCenter = CGPointMake(  message.center.x
                                        , message.viewController.view.bounds.size.height + (message.frame.size.height / 2.0f) );
            break;
        case MessageBannerPositionCenter:
            if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
                
                UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer*)gesture;
                switch (swipeGesture.direction) {
                        
                    case UISwipeGestureRecognizerDirectionLeft:
                        fadeOutCenter = CGPointMake(  -(message.center.x)
                                                    , message.center.y);
                        break;
                    case UISwipeGestureRecognizerDirectionRight:
                        fadeOutCenter = CGPointMake(  message.center.x + message.viewController.view.bounds.size.width
                                                    , message.center.y);
                    default:
                        break;
                }
            } else {
                fadeOutCenter = CGPointMake(  -(message.center.x)
                                            , message.center.y);
            }
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [message setCenter:fadeOutCenter];
    } completion:^(BOOL finished) {
#warning add Callback for  future delegate
        [message removeFromSuperview];
        [[[MessageBanner sharedSingleton] messagesBannersList] removeObjectAtIndex:0];
        [MessageBanner sharedSingleton].messageOnScreen = NO;
        if ([[[MessageBanner sharedSingleton] messagesBannersList] count]) {
            [[MessageBanner sharedSingleton] showMessageBannerOnScreen];
        }
    }];
}


#pragma mark -
#pragma mark Hide Message Banner timer method
- (void) initAutoDismissTimerforBanner:(MessageBannerView *)message {
    CGFloat timerSec = ANIMATION_DURATION;
    
    if (message.duration != MessageBannerDurationEndless) {
        
        if (message.duration == MessageBannerDurationDefault) {
            timerSec += DISPLAY_DEFAULT_DURATION + (message.frame.size.height * DISPLAY_TIME_PER_PIXEL);
        } else {
            timerSec += message.duration;
        }
        
#warning change hideMessageBanner Prototype to remove gesture reconizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        NSMethodSignature *meth = [MessageBanner methodSignatureForSelector:@selector(hideMessageBanner:withGesture:)];
        NSInvocation *hideMethodInvocation = [NSInvocation invocationWithMethodSignature:meth];
        [hideMethodInvocation setSelector:@selector(hideMessageBanner:withGesture:)];
        [hideMethodInvocation setTarget:[MessageBanner class]];
        [hideMethodInvocation setArgument:&message atIndex:2];
        [hideMethodInvocation setArgument:&tap atIndex:3];
        [hideMethodInvocation retainArguments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            message.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:timerSec invocation:hideMethodInvocation repeats:NO];
        });
    }
}


@end
