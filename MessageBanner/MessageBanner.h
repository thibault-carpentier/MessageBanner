//
//  MessageBanner.h
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@class MessageBannerView;

@interface MessageBanner : NSObject

@property (nonatomic, readonly, strong) NSMutableArray *messagesBannersList;
@property (nonatomic, assign)           BOOL            messageOnScreen;

+ (instancetype) sharedSingleton;

+ (void)showMessageBannerInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                   image:(UIImage *)image
                                    type:(MessageBannerType)type
                                duration:(NSTimeInterval)duration
                                userDissmissedCallback:(void (^)(MessageBannerView* bannerView))userDissmissedCallback
                             buttonTitle:(NSString *)buttonTitle
                          buttonCallback:(void (^)())buttonCallback
                              atPosition:(MessageBannerPosition)messagePosition
                    canBeDismissedByUser:(BOOL)dismissingEnabled;

+ (void)prepareMessageBanner:(MessageBannerView *)messageBanner;

+ (void) hideMessageBanner:(MessageBannerView *)messageBanner
              withGesture:(UIGestureRecognizer *)gesture;


@end
