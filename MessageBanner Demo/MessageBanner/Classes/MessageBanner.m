/**
 * @file   MessageBanner.m
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MessageBannerView manager.
 *
 * MessageBanner allow to easilly manage popups.
 */

#import "MessageBanner.h"
#import "MessageBannerView.h"

#pragma mark - MessageBanner interface
@interface MessageBanner ()
/**
 Determine if a message is on the screen or not
 */
@property (nonatomic, assign) BOOL            messageOnScreen;
/**
 The list of message to be shown
 */
@property (nonatomic, strong) NSMutableArray *messagesBannersList;
@end

#pragma mark - MessageBannerView usefull methods
/**
 Undocumented private methods calls for internal use
 */
@interface MessageBannerView ()
    - (void)setBlur;
    - (void)unsetBlur;
@end

@implementation MessageBanner


#pragma mark - Default Calculation duration values
/**
 Default class animation duration
 */
#define ANIMATION_DURATION 0.5
/**
 Default class display time per pixel user in automatic duration calculs
 */
#define DISPLAY_TIME_PER_PIXEL 0.04
/**
 Default display duration used in automatic duration calculs
 */
#define DISPLAY_DEFAULT_DURATION 2.0


#pragma mark - Default Message Banner configuration
/**
 Default banner type
 */
#define TYPE_DEFAULT            MessageBannerTypeMessage
/**
 Default message banner duration mode
 */
#define DURATION_DEFAULT        MessageBannerDurationDefault
/**
 Default message banner position mode
 */
#define POSITION_DEFAULT        MessageBannerPositionTop
/**
 Default user dismiss message banner mode
 */
#define USER_DISMISS_DEFAULT    YES

#pragma mark - static instances
/**
 Singleton instance
 */
static MessageBanner *sharedSingleton;
/**
 Default view controller used if viewcontroller is nil or not passed as a parameter
 */
static UIViewController* _defaultViewController;
/**
 Class delegate instance
 */
static id <MessageBannerDelegate> _delegate;
/**
 Caching delegate methods implementation stucture
 */
static struct delegateMethodsCaching {
    
    unsigned int messageBannerViewWillAppear:1;
    unsigned int MessageBannerViewDidAppear:1;
    unsigned int MessageBannerViewWillDisappear:1;
    unsigned int MessageBannerViewDidDisappear:1;
    
} _delegateRespondTo;


#pragma mark - Init and singleton methods
/**
 Returns the shared instance of the manager
 @returns manager shared instance
 */
+ (MessageBanner *)sharedSingleton
{
    if (!sharedSingleton)
    {
        sharedSingleton = [[[self class] alloc] init];
    }
    return sharedSingleton;
}

+ (UIViewController*)defaultViewController {
    __strong UIViewController* defaultViewController = _defaultViewController;
    if (!defaultViewController) {
        defaultViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return defaultViewController;
}

- (id)init {
    if ((self = [super init])) {
        _messagesBannersList = [[NSMutableArray alloc] init];
        _messageOnScreen = NO;
    }
    return self;
}

#pragma mark -
#pragma mark Default view controller methods

+ (void)setDefaultViewController:(UIViewController *)aViewController {
    _defaultViewController = aViewController;
}

#pragma mark -
#pragma mark Delegate Methods

+ (void)setMessageBannerDelegate:(id<MessageBannerDelegate>)aDelegate {
    if (_delegate != aDelegate) {
        
        _delegate = aDelegate;
        
        struct delegateMethodsCaching newMethodCaching;
        
        newMethodCaching.messageBannerViewWillAppear = [_delegate respondsToSelector:@selector(messageBannerViewWillAppear:)];
        
        newMethodCaching.MessageBannerViewDidAppear = [_delegate respondsToSelector:@selector(messageBannerViewDidAppear:)];
        
        newMethodCaching.MessageBannerViewWillDisappear = [_delegate respondsToSelector:@selector(messageBannerViewWillDisappear:)];
        
        newMethodCaching.MessageBannerViewDidDisappear = [_delegate respondsToSelector:@selector(messageBannerViewDidDisappear:)];
        
        _delegateRespondTo = newMethodCaching;
    }
}

#pragma mark -
#pragma mark Show methods

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle {
    [self showMessageBannerInViewController:viewController
                                      title:title
                                   subtitle:subtitle
                                      image:nil
                                       type:TYPE_DEFAULT
                                   duration:DURATION_DEFAULT
                     userDissmissedCallback:nil
                                buttonTitle:nil
                  userPressedButtonCallback:nil
                                 atPosition:POSITION_DEFAULT
                       canBeDismissedByUser:USER_DISMISS_DEFAULT
                                   delegate:nil];
}

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                               atPosition:(MessageBannerPosition)messagePosition {
    
    [self showMessageBannerInViewController:viewController
                                      title:title
                                   subtitle:subtitle
                                      image:nil
                                       type:TYPE_DEFAULT
                                   duration:DURATION_DEFAULT
                     userDissmissedCallback:nil
                                buttonTitle:nil
                  userPressedButtonCallback:nil
                                 atPosition:messagePosition
                       canBeDismissedByUser:USER_DISMISS_DEFAULT
                                   delegate:nil];
}

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                               atPosition:(MessageBannerPosition)messagePosition {
    
    [self showMessageBannerInViewController:viewController
                                      title:title
                                   subtitle:subtitle
                                      image:nil
                                       type:type
                                   duration:DURATION_DEFAULT
                     userDissmissedCallback:nil
                                buttonTitle:nil
                  userPressedButtonCallback:nil
                                 atPosition:messagePosition
                       canBeDismissedByUser:USER_DISMISS_DEFAULT
                                   delegate:nil];
}

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                               atPosition:(MessageBannerPosition)messagePosition {
    
    [self showMessageBannerInViewController:viewController
                                      title:title
                                   subtitle:subtitle
                                      image:nil
                                       type:type
                                   duration:duration
                     userDissmissedCallback:nil
                                buttonTitle:nil
                  userPressedButtonCallback:nil
                                 atPosition:messagePosition
                       canBeDismissedByUser:USER_DISMISS_DEFAULT
                                   delegate:nil];
}

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MessageBannerView *))userDissmissedCallback
                               atPosition:(MessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled {
    
    [self showMessageBannerInViewController:viewController
                                      title:title
                                   subtitle:subtitle
                                      image:nil
                                       type:type
                                   duration:duration
                     userDissmissedCallback:userDissmissedCallback
                                buttonTitle:nil
                  userPressedButtonCallback:nil
                                 atPosition:messagePosition
                       canBeDismissedByUser:dismissingEnabled
                                   delegate:nil];
}

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                    image:(UIImage *)image
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MessageBannerView *))userDissmissedCallback
                               atPosition:(MessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled {
    [self showMessageBannerInViewController:viewController
                                      title:title
                                   subtitle:subtitle
                                      image:image
                                       type:type
                                   duration:duration
                     userDissmissedCallback:userDissmissedCallback
                                buttonTitle:nil
                  userPressedButtonCallback:nil
                                 atPosition:messagePosition
                       canBeDismissedByUser:dismissingEnabled
                                   delegate:nil];
}

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
                     canBeDismissedByUser:(BOOL)dismissingEnabled
                    delegate:(id<MessageBannerDelegate>)aDelegate {
    
    
    // if not correctlyset, we use the default view controller
    if (!viewController) {
        viewController = [MessageBanner defaultViewController];
    }
    
    MessageBannerView *messageBannerView = [[MessageBannerView alloc] initWithTitle:title subtitle:subtitle image:image type:type duration:duration inViewController:viewController userDissmissedCallback:userDissmissedCallback buttonTitle:buttonTitle userPressedButtonCallback:userPressedButtonCallback atPosition:messagePosition canBeDismissedByUser:dismissingEnabled];
    
    
    // Preparing and showing notification
#warning uncomment after testing
    
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
    
    
    if (_delegate == nil) {
        [MessageBanner setMessageBannerDelegate:aDelegate];
    }
    [[MessageBanner sharedSingleton].messagesBannersList addObject:messageBannerView];
    
    if ([[MessageBanner sharedSingleton] messageOnScreen] == NO) {
        [[MessageBanner sharedSingleton] showMessageBannerOnScreen];
    }
}

#pragma mark -
#pragma mark Fade-in Message Banner methods

- (void)showMessageBannerOnScreen {
    
    _messageOnScreen = YES;
    
    if (![[MessageBanner sharedSingleton].messagesBannersList count]) {
        NSLog(@"No Message Banner to show");
        return;
    }
    
    MessageBannerView *currentMessageBanner = [[MessageBanner sharedSingleton].messagesBannersList firstObject];
    
    if (_delegate && _delegateRespondTo.messageBannerViewWillAppear == YES) {
        [_delegate messageBannerViewWillAppear:currentMessageBanner];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BANNER_VIEW_WILL_APPEAR_NOTIFICATION object:currentMessageBanner];
    
    [currentMessageBanner setBlur];
    
    CGPoint target = [self calculateTargetCenter:currentMessageBanner];
    [UIView animateKeyframesWithDuration:ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        currentMessageBanner.center = target;
        
    } completion:^(BOOL finished) {
        currentMessageBanner.isBannerDisplayed = YES;
        if (_delegate && _delegateRespondTo.MessageBannerViewDidAppear == YES) {
            [_delegate messageBannerViewDidAppear:currentMessageBanner];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BANNER_VIEW_DID_APPEAR_NOTIFICATION object:currentMessageBanner];
    }];
    
    [self initAutoDismissTimerforBanner:currentMessageBanner];
}

#pragma mark -
#pragma mark Hide Message Banner methods

+ (BOOL)hideMessageBanner {
    return [self hideMessageBannerWithCompletion:nil];
}

+ (BOOL) hideMessageBannerWithCompletion:(void (^)())completion {
    BOOL success = NO;
    
    if ([[[MessageBanner sharedSingleton] messagesBannersList] count]) {
        success = YES;
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           if ([[[MessageBanner sharedSingleton] messagesBannersList] count]) {
                               
                               MessageBannerView *currentView = [[[MessageBanner sharedSingleton] messagesBannersList] objectAtIndex:0];
                               if (currentView.isBannerDisplayed)
                               {
                                   [[MessageBanner sharedSingleton] hideMessageBanner:currentView withGesture:nil andCompletion:completion];
                               }
                           }
                       });
    
    }
    return success;
}

#pragma mark -
#pragma mark Fade-out Message Banner methods

- (void) hideMessageBanner:(MessageBannerView *)message withGesture:(UIGestureRecognizer *)gesture andCompletion:(void (^)())completion {
    
    //    Removing timer Callback
    message.isBannerDisplayed = NO;
    
    if (message.duration != MessageBannerDurationEndless) {
        [message.dismissTimer invalidate];
    }
    
    if (_delegate && _delegateRespondTo.MessageBannerViewWillDisappear == YES) {
        [_delegate messageBannerViewWillDisappear:message];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BANNER_VIEW_WILL_DISAPPEAR_NOTIFICATION object:message];
    
    [message unsetBlur];
    
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
        [message removeFromSuperview];
        [[[MessageBanner sharedSingleton] messagesBannersList] removeObjectAtIndex:0];
        [MessageBanner sharedSingleton].messageOnScreen = NO;
        
        if (completion) {
            completion();
        }
        
        
        if (_delegate && _delegateRespondTo.MessageBannerViewDidDisappear == YES) {
            [_delegate messageBannerViewDidDisappear:message];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BANNER_VIEW_DID_DISAPPEAR_NOTIFICATION object:message];

        
        if ([[[MessageBanner sharedSingleton] messagesBannersList] count]) {
            [[MessageBanner sharedSingleton] showMessageBannerOnScreen];
        }
        
         }];
}

#pragma mark -
#pragma mark Message Banner Timer method

- (void) initAutoDismissTimerforBanner:(MessageBannerView *)message {
    CGFloat timerSec = ANIMATION_DURATION;
    
    if (message.duration != MessageBannerDurationEndless) {
        
        if (message.duration == MessageBannerDurationDefault) {
            timerSec += DISPLAY_DEFAULT_DURATION + (message.frame.size.height * DISPLAY_TIME_PER_PIXEL);
        } else {
            timerSec += message.duration;
        }
        
        UITapGestureRecognizer *tap = nil;
        void (^completion)() = nil;
        NSMethodSignature *meth = [[MessageBanner sharedSingleton]methodSignatureForSelector:@selector(hideMessageBanner:withGesture:andCompletion:)];
        NSInvocation *hideMethodInvocation = [NSInvocation invocationWithMethodSignature:meth];
        [hideMethodInvocation setSelector:@selector(hideMessageBanner:withGesture:andCompletion:)];
        [hideMethodInvocation setTarget:[MessageBanner sharedSingleton]];
        [hideMethodInvocation setArgument:&message atIndex:2];
        [hideMethodInvocation setArgument:&tap atIndex:3];
        [hideMethodInvocation setArgument:&completion atIndex:4];
        [hideMethodInvocation retainArguments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            message.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:timerSec invocation:hideMethodInvocation repeats:NO];
        });
    }
}

#pragma mark -
#pragma mark Calculate new center methods
- (CGFloat) getStatusBarSize {
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    CGFloat offset = isPortrait ? statusBarSize.height : statusBarSize.width;
    
    return (offset);
}

-(CGFloat)calculateTopOffsetAndAttachView:(MessageBannerView *)message {
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

-(CGFloat)calculateBottomOffsetAndAttachView:(MessageBannerView *)message {
    CGFloat bottomOffset = 0.0f;
    UINavigationController *currentNavigationController;

    if ([message.viewController isKindOfClass:[UINavigationController class]] || [message.viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        // Getting the current view Controller
        if ([message.viewController isKindOfClass:[UINavigationController class]]) {
            currentNavigationController = (UINavigationController *)message.viewController;
        } else {
            currentNavigationController = (UINavigationController *)message.viewController.parentViewController;
        }
    } else {
        currentNavigationController = message.viewController.navigationController;
    }
    
    if (currentNavigationController && currentNavigationController.isToolbarHidden == NO) {
        bottomOffset = (currentNavigationController.toolbar.frame.size.height);
        [currentNavigationController.view insertSubview:message belowSubview:currentNavigationController.toolbar];
    } else {
        [message.viewController.view addSubview:message];
    }

    return bottomOffset;
}


- (CGPoint)calculateTargetCenter:(MessageBannerView *)message {
    CGPoint result;
    
    switch (message.position) {
        case MessageBannerPositionTop:
            result = CGPointMake(  message.center.x
                                 , (message.frame.size.height / 2.0f) + [self calculateTopOffsetAndAttachView:message]);
            break;
        case MessageBannerPositionBottom:
            result = CGPointMake( message.center.x, message.viewController.view.frame.size.height - ((message.frame.size.height / 2.0f) + [self calculateBottomOffsetAndAttachView:message]));
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

@end
