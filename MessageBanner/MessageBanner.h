//
//  MessageBanner.h
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessageBannerView;

typedef NS_ENUM(NSInteger, MessageBannerType) {
    MessageBannerTypeMessage  = 0
    , MessageBannerTypeWarning  = 1
    , MessageBannerTypeError    = 2
    , MessageBannerTypeSuccess  = 3
};

typedef NS_ENUM(NSInteger, MessageBannerPosition) {
    MessageBannerPositionTop    = 0
    , MessageBannerPositionCenter = 1
    , MessageBannerPositionBottom = 2
};

typedef NS_ENUM(NSInteger, MessageBannerDuration) {
      MessageBannerDurationDefault = 0
    , MessageBannerDurationEndless = -1
};

@protocol MessageBannerDelegate <NSObject>

@optional

- (void)messageBannerViewWillAppear:(MessageBannerView *)messageBanner;
- (void)messageBannerViewDidAppear:(MessageBannerView *)messageBanner;
- (void)messageBannerViewWillDisappear:(MessageBannerView *)messageBanner;
- (void)messageBannerViewDidDisappear:(MessageBannerView *)messageBanner;

@end




@interface MessageBanner : NSObject

+ (instancetype) sharedSingleton;

#pragma mark - Set Default vars

+ (void)setMessageBannerDelegate:(id<MessageBannerDelegate>)aDelegate;

#pragma mark - Show Methods

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                               atPosition:(MessageBannerPosition)messagePosition;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                               atPosition:(MessageBannerPosition)messagePosition;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                               atPosition:(MessageBannerPosition)messagePosition;


+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;


+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                    title:(NSString *)title
                                 subtitle:(NSString *)subtitle
                                    image:(UIImage *)image
                                     type:(MessageBannerType)type
                                 duration:(NSTimeInterval)duration
                   userDissmissedCallback:(void (^)(MessageBannerView* bannerView))userDissmissedCallback
                               atPosition:(MessageBannerPosition)messagePosition
                     canBeDismissedByUser:(BOOL)dismissingEnabled;

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

+ (BOOL) hideMessageBanner;
+ (BOOL) hideMessageBannerWithCompletion:(void (^)())completion;

@end
