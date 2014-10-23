/**
 * @file   MBLMessageBanner.m
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MBLMessageBannerView manager.
 *
 * MBLMessageBanner allow to easilly manage popups.
 */

#import "MBLMessageBanner.h"
#import "MBLMessageBannerView.h"

#pragma mark - MBLMessageBanner interface
@interface MBLMessageBanner ()
/**
 Determine if a message is on the screen or not
 */
@property (nonatomic, assign) BOOL            messageOnScreen;
/**
 The list of message to be shown
 */
@property (nonatomic, strong) NSMutableArray *messagesBannersList;
@end

#pragma mark - MBLMessageBannerView usefull methods
/**
 Undocumented private methods calls for internal use
 */
@interface MBLMessageBannerView ()
    - (void)setBlur;
    - (void)unsetBlur;
@end

@implementation MBLMessageBanner


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
#define TYPE_DEFAULT            MBLMessageBannerTypeMessage
/**
 Default message banner duration mode
 */
#define DURATION_DEFAULT        MBLMessageBannerDurationDefault
/**
 Default message banner position mode
 */
#define POSITION_DEFAULT        MBLMessageBannerPositionTop
/**
 Default user dismiss message banner mode
 */
#define USER_DISMISS_DEFAULT    YES

#pragma mark - static instances
/**
 Singleton instance
 */
static MBLMessageBanner *sharedSingleton;
/**
 Default view controller used if viewcontroller is nil or not passed as a parameter
 */
static UIViewController* _defaultViewController;
/**
 Class delegate instance
 */
static id <MBLMessageBannerDelegate> _delegate;
/**
 Caching delegate methods implementation stucture
 */
static struct delegateMethodsCaching {
    
    unsigned int messageBannerViewWillAppear:1;
    unsigned int messageBannerViewDidAppear:1;
    unsigned int messageBannerViewWillDisappear:1;
    unsigned int messageBannerViewDidDisappear:1;
    
} _delegateRespondTo;


#pragma mark - Init and singleton methods
/**
 Returns the shared instance of the manager
 @returns manager shared instance
 */
+ (MBLMessageBanner *)sharedSingleton
{
    if (!sharedSingleton)
    {
        sharedSingleton = [[[self class] alloc] init];
    }
    return sharedSingleton;
}
/**
 Returns the default view controller
 @returns the default view controller where the banner is attached if the viewcontroller parameter is nil
 */
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
/**
 Set the default view controller
 @param aViewController The new controller to set as default
 */
+ (void)setDefaultViewController:(UIViewController *)aViewController {
    _defaultViewController = aViewController;
}

#pragma mark -
#pragma mark Delegate Methods

+ (void)setMessageBannerDelegate:(id<MBLMessageBannerDelegate>)aDelegate {
    if (_delegate != aDelegate) {
        
        _delegate = aDelegate;
        
        struct delegateMethodsCaching newMethodCaching;
        
        newMethodCaching.messageBannerViewWillAppear = [_delegate respondsToSelector:@selector(messageBannerViewWillAppear:)];
        
        newMethodCaching.messageBannerViewDidAppear = [_delegate respondsToSelector:@selector(messageBannerViewDidAppear:)];
        
        newMethodCaching.messageBannerViewWillDisappear = [_delegate respondsToSelector:@selector(messageBannerViewWillDisappear:)];
        
        newMethodCaching.messageBannerViewDidDisappear = [_delegate respondsToSelector:@selector(messageBannerViewDidDisappear:)];
        
        _delegateRespondTo = newMethodCaching;
    }
}

#pragma mark -
#pragma mark Show methods

+ (void)showMessageBanner:(MBLMessageBannerView *)messageBannerView {


    // Preparing and showing notification Future version protection
    //#warning uncomment after testing

    //    NSString *title = messageBannerView.title;
    //    NSString *subtitle = messageBannerView.subTitle;
    //    for (MBLMessageBannerView *n in [MBLMessageBanner sharedSingleton].messagesBannersList)
    //    {
    //        if (([n.title isEqualToString:title] || (!n.title && !title)) && ([n.subTitle isEqualToString:subtitle] || (!n.subTitle && !subtitle)))
    //        {
    //            // Add some check in the config file later if it allow multiple pop-ups
    //            return;
    //        }
    //    }

    [[MBLMessageBanner sharedSingleton].messagesBannersList addObject:messageBannerView];

    if ([[MBLMessageBanner sharedSingleton] messageOnScreen] == NO) {
        [[MBLMessageBanner sharedSingleton] showMessageBannerOnScreen];
    }
}

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
                               atPosition:(MBLMessageBannerPosition)messagePosition {
    
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
                                     type:(MBLMessageBannerType)type
                               atPosition:(MBLMessageBannerPosition)messagePosition {
    
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
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                               atPosition:(MBLMessageBannerPosition)messagePosition {
    
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
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MBLMessageBannerView *))userDissmissedCallback
                               atPosition:(MBLMessageBannerPosition)messagePosition
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
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MBLMessageBannerView *))userDissmissedCallback
                               atPosition:(MBLMessageBannerPosition)messagePosition
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
                                     type:(MBLMessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MBLMessageBannerView *bannerView))userDissmissedCallback
                              buttonTitle:(NSString *)buttonTitle
                userPressedButtonCallback:(void (^)(MBLMessageBannerView* banner))userPressedButtonCallback
                               atPosition:(MBLMessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled
                    delegate:(id<MBLMessageBannerDelegate>)aDelegate {

    if (!viewController) {
        viewController = [MBLMessageBanner defaultViewController];
    }

    MBLMessageBannerView *messageBannerView = [[MBLMessageBannerView alloc] initWithTitle:title subtitle:subtitle image:image type:type duration:duration inViewController:viewController userDissmissedCallback:userDissmissedCallback buttonTitle:buttonTitle userPressedButtonCallback:userPressedButtonCallback atPosition:messagePosition canBeDismissedByUser:dismissingEnabled];

    if (_delegate == nil) {
        [MBLMessageBanner setMessageBannerDelegate:aDelegate];
    }
    [self showMessageBanner:messageBannerView];
}

#pragma mark -
#pragma mark Fade-in Message Banner methods

- (UIViewController *)getParentViewController:(MBLMessageBannerView*)message {
    UIViewController *parentViewController;
    
    if ([self isViewControllerOrParentViewControllerNavigationController:message]) {
        // Getting the current view Controller
        UINavigationController *currentNavigationController;
        if ([self isViewControllerNavigationController:message]) {
            currentNavigationController = (UINavigationController *)message.viewController;
        } else {
            currentNavigationController = (UINavigationController *)message.viewController.parentViewController;
        }
        switch (message.position) {
            case MBLMessageBannerPositionTop:
                if ([self isNavigationBarVisible:currentNavigationController]) {
                    parentViewController = currentNavigationController;
                }
                else {
                    parentViewController = message.viewController;
                }
                break;
            case MBLMessageBannerPositionCenter: {
                parentViewController = message.viewController;
                break;
            }
            case MBLMessageBannerPositionBottom:
                if ([self isToolBarHidden:currentNavigationController]) {
                    parentViewController = currentNavigationController;
                }
                else {
                    parentViewController = message.viewController;
                }
                break;
                
            default:
                break;
        }
    }
    else {
        parentViewController = message.viewController;
    }
    
    return parentViewController;
}

-(void)attachVerticalBannerConstraint:(MBLMessageBannerView*)message onViewController:(UIViewController*)viewController {
    
    switch (message.position) {
        case MBLMessageBannerPositionTop: {
            UIViewController* realViewController;
            
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                realViewController = [(UINavigationController*)viewController visibleViewController];
            } else {
                realViewController = viewController;
            }
            
            [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:realViewController.topLayoutGuide
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:message
                                                                            attribute:NSLayoutAttributeTop
                                                                           multiplier:1.0f
                                                                             constant:0.0f]];
            break;
        }
        case MBLMessageBannerPositionCenter: {
            
            [viewController.view addConstraint:
             [NSLayoutConstraint constraintWithItem:viewController.view
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:message
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0f
                                           constant:0.0f]];
            break;
        }
        case MBLMessageBannerPositionBottom: {

            UIViewController* realViewController;
            
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                realViewController = [(UINavigationController*)viewController visibleViewController];
            } else {
                realViewController = viewController;
            }
            
            [viewController.view addConstraint:
             [NSLayoutConstraint constraintWithItem:realViewController.bottomLayoutGuide
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:message
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1.0f
                                           constant:0.0f]];
            break;
        }
        default:
            break;
    }
}

-(void)attachBannerConstraints:(MBLMessageBannerView*)message onViewController:(UIViewController*)viewController {
    
    // Adding horizontal allignment
    [viewController.view addConstraint:
     [NSLayoutConstraint constraintWithItem:viewController.view
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:message
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:1.0f
                                   constant:0.0f]
     ];
    
    [viewController.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-0-[message]-0-|"
                                             options: 0
                                             metrics: nil
                                               views: NSDictionaryOfVariableBindings(message)]
     ];
    
    [self attachVerticalBannerConstraint:message onViewController:viewController];

}

- (void)showMessageBannerOnScreen {
    
    _messageOnScreen = YES;
    
    if (![[MBLMessageBanner sharedSingleton].messagesBannersList count]) {
        NSLog(@"No Message Banner to show");
        return;
    }
    
    MBLMessageBannerView *currentMessageBanner = [[MBLMessageBanner sharedSingleton].messagesBannersList firstObject];
    
    if (_delegate && _delegateRespondTo.messageBannerViewWillAppear == YES) {
        [_delegate messageBannerViewWillAppear:currentMessageBanner];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BANNER_VIEW_WILL_APPEAR_NOTIFICATION object:currentMessageBanner];
    
    [currentMessageBanner setBlur];
    
    CGPoint target = [self calculateTargetCenter:currentMessageBanner];
    [self attachBannerConstraints:currentMessageBanner onViewController:[self getParentViewController:currentMessageBanner]];
    
    [UIView animateKeyframesWithDuration:ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        
        currentMessageBanner.center = target;
        
    } completion:^(BOOL finished) {
        
        currentMessageBanner.isBannerDisplayed = YES;
        if (_delegate && _delegateRespondTo.messageBannerViewDidAppear == YES) {
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
    
    if ([[[MBLMessageBanner sharedSingleton] messagesBannersList] count]) {
        success = YES;
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           if ([[[MBLMessageBanner sharedSingleton] messagesBannersList] count]) {
                               
                               MBLMessageBannerView *currentView = [[[MBLMessageBanner sharedSingleton] messagesBannersList] objectAtIndex:0];
                               if (currentView.isBannerDisplayed)
                               {
                                   [[MBLMessageBanner sharedSingleton] hideMessageBanner:currentView withGesture:nil andCompletion:completion];
                               }
                           }
                       });
    
    }
    return success;
}

#pragma mark -
#pragma mark Fade-out Message Banner methods

- (void) hideMessageBanner:(MBLMessageBannerView *)message withGesture:(UIGestureRecognizer *)gesture andCompletion:(void (^)())completion {
    
    //    Removing timer Callback
    message.isBannerDisplayed = NO;
    
    if (message.duration != MBLMessageBannerDurationEndless) {
        [message.dismissTimer invalidate];
    }
    
    if (_delegate && _delegateRespondTo.messageBannerViewWillDisappear == YES) {
        [_delegate messageBannerViewWillDisappear:message];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BANNER_VIEW_WILL_DISAPPEAR_NOTIFICATION object:message];
    
    [message unsetBlur];
    
    CGPoint fadeOutCenter = CGPointMake(0, 0);
    
    switch (message.position) {
        case MBLMessageBannerPositionTop:
            fadeOutCenter = CGPointMake(  message.center.x
                                        , -(message.frame.size.height / 2.0f) );
            break;
        case MBLMessageBannerPositionBottom:
            fadeOutCenter = CGPointMake(  message.center.x
                                        , message.viewController.view.bounds.size.height + (message.frame.size.height / 2.0f) );
            break;
        case MBLMessageBannerPositionCenter:
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
        [[[MBLMessageBanner sharedSingleton] messagesBannersList] removeObjectAtIndex:0];
        [MBLMessageBanner sharedSingleton].messageOnScreen = NO;
        
        if (completion) {
            completion();
        }
        
        
        if (_delegate && _delegateRespondTo.messageBannerViewDidDisappear == YES) {
            [_delegate messageBannerViewDidDisappear:message];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_BANNER_VIEW_DID_DISAPPEAR_NOTIFICATION object:message];

        
        if ([[[MBLMessageBanner sharedSingleton] messagesBannersList] count]) {
            [[MBLMessageBanner sharedSingleton] showMessageBannerOnScreen];
        }
        
         }];
}

#pragma mark -
#pragma mark Message Banner Timer method

- (void) initAutoDismissTimerforBanner:(MBLMessageBannerView *)message {
    CGFloat timerSec = ANIMATION_DURATION;
    
    if (message.duration != MBLMessageBannerDurationEndless) {
        
        if (message.duration == MBLMessageBannerDurationDefault) {
            timerSec += DISPLAY_DEFAULT_DURATION + (message.frame.size.height * DISPLAY_TIME_PER_PIXEL);
        } else {
            timerSec += message.duration;
        }
        
        UITapGestureRecognizer *tap = nil;
        void (^completion)() = nil;
        NSMethodSignature *meth = [[MBLMessageBanner sharedSingleton]methodSignatureForSelector:@selector(hideMessageBanner:withGesture:andCompletion:)];
        NSInvocation *hideMethodInvocation = [NSInvocation invocationWithMethodSignature:meth];
        [hideMethodInvocation setSelector:@selector(hideMessageBanner:withGesture:andCompletion:)];
        [hideMethodInvocation setTarget:[MBLMessageBanner sharedSingleton]];
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

-(CGFloat)calculateTopOffsetAndAttachView:(MBLMessageBannerView *)message {
    CGFloat topOffset = 0.0f;
    
    // If has a navigationController
    if ([self isViewControllerOrParentViewControllerNavigationController:message]) {
        
        // Getting the current view Controller
        UINavigationController *currentNavigationController;
        if ([self isViewControllerNavigationController:message]) {
            currentNavigationController = (UINavigationController *)message.viewController;
        } else {
            currentNavigationController = (UINavigationController *)message.viewController.parentViewController;
        }
        
        // If the navigationBar is visible we add his height as an offset
        if ([self isNavigationBarVisible:currentNavigationController]) {
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

-(CGFloat)calculateBottomOffsetAndAttachView:(MBLMessageBannerView *)message {
    CGFloat bottomOffset = 0.0f;
    UINavigationController *currentNavigationController;

    if ([self isViewControllerOrParentViewControllerNavigationController:message]) {
        
        // Getting the current view Controller
        if ([self isViewControllerNavigationController:message]) {
            currentNavigationController = (UINavigationController *)message.viewController;
        } else {
            currentNavigationController = (UINavigationController *)message.viewController.parentViewController;
        }
    } else {
        currentNavigationController = message.viewController.navigationController;
    }
    
    if ([self isToolBarHidden:currentNavigationController]) {
        bottomOffset = (currentNavigationController.toolbar.frame.size.height);
        [currentNavigationController.view insertSubview:message belowSubview:currentNavigationController.toolbar];
    } else {
        [message.viewController.view addSubview:message];
    }
    return bottomOffset;
}


- (CGPoint)calculateTargetCenter:(MBLMessageBannerView *)message {
    CGPoint result;
    
    switch (message.position) {
        case MBLMessageBannerPositionTop:
            result = CGPointMake(  message.center.x
                                 , (message.frame.size.height / 2.0f) + [self calculateTopOffsetAndAttachView:message]);
            break;
        case MBLMessageBannerPositionBottom:
            result = CGPointMake( message.center.x, message.viewController.view.frame.size.height - ((message.frame.size.height / 2.0f) + [self calculateBottomOffsetAndAttachView:message]));
            break;
        case MBLMessageBannerPositionCenter:
            
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

#pragma mark -
#pragma mark Checks Methods

- (BOOL)isViewControllerOrParentViewControllerNavigationController:(MBLMessageBannerView *)message {
    return ([message.viewController isKindOfClass:[UINavigationController class]]
            || [message.viewController.parentViewController isKindOfClass:[UINavigationController class]]);
}

- (BOOL)isViewControllerNavigationController:(MBLMessageBannerView *)message {
    return ([message.viewController isKindOfClass:[UINavigationController class]]);
}

- (BOOL)isNavigationBarVisible:(UINavigationController *)currentNavigationController {
    return (![currentNavigationController isNavigationBarHidden] &&
            ![[currentNavigationController navigationBar] isHidden]);
}

- (BOOL)isToolBarHidden:(UINavigationController *)currentNavigationController {
    return (currentNavigationController && currentNavigationController.isToolbarHidden == NO);
}

@end
