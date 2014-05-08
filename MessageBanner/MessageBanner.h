//
//  MessageBanner.h
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MessageBannerType) {
    MessageBannerNotificationTypeMessage  = 0
    , MessageBannerNotificationTypeWarning  = 1
    , MessageBannerNotificationTypeError    = 2
    , MessageBannerNotificationTypeSuccess  = 3
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

@property (nonatomic, strong) NSMutableArray *notificationsList;
@property (nonatomic, assign) BOOL messageOnScreen;

+ (instancetype) sharedSingleton;

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
                    canBeDismissedByUser:(BOOL)dismissingEnabled;

+ (void)prepareNotification:(MessageBannerView *)notificationView;

+ (void) hideNotification:(MessageBannerView *)message
              withGesture:(UIGestureRecognizer *)gesture;


@end
