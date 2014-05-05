//
//  MessageBannerView.m
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import "MessageBannerView.h"

#define ELEMENTS_PADDING 16.0f

@interface MessageBannerView ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

@property (nonatomic, assign) CGFloat  messageViewHeight;
@end

@implementation MessageBannerView

#pragma mark -
#pragma mark Init and dismiss methods

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
canBeDismissedByUser:(BOOL)dismissingEnabled {
    if ((self = [self init])) {

        _title = title;
        _subTitle = subtitle;
        _viewController = viewController;
        _image = image;
        _duration = duration;
        _position = position;
        
        self.messageViewHeight = 0.0f;
        
// To be declined according to position;
        
//        Setting up title
        self.titleLabel = [self createMessageTitle];
        [self addSubview:self.titleLabel];
        
        
//        Setting up subtitle
        self.subtitleLabel = [self createSubtitleLabel];
        [self addSubview:self.subtitleLabel];
        
//        Setting up frames
        [self setTitleFrame:self.titleLabel];
        [self setSubtitleFrame:self.subtitleLabel];
        
//        Setting message frame :
        [self setFrame:[self createViewFrame]];
        
        
        
//        Adding dismiss gesture
        if (dismissingEnabled) {
            [self addDismissMethod];
        }
        
#warning to remove
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)dismissViewWithGesture:(UIGestureRecognizer*)gesture {
    
    
    CGPoint fadeOutCenter = CGPointMake(0, 0);
    
    switch (self.position) {
        case MessageBannerPositionTop:
            fadeOutCenter = CGPointMake(  self.center.x
                                        , -(self.frame.size.height / 2.0f) );
            break;
        case MessageBannerPositionBottom:
            fadeOutCenter = CGPointMake(  self.center.x
                                        , self.viewController.view.bounds.size.height + (self.frame.size.height / 2.0f) );
            break;
        case MessageBannerPositionCenter:
            if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
                
                UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer*)gesture;
                switch (swipeGesture.direction) {
                        
                    case UISwipeGestureRecognizerDirectionLeft:
                        fadeOutCenter = CGPointMake(  -(self.center.x)
                                                    , self.center.y);
                        break;
                    case UISwipeGestureRecognizerDirectionRight:
                        fadeOutCenter = CGPointMake(  self.center.x + self.viewController.view.bounds.size.width
                                                    , self.center.y);
                    default:
                        break;
                }
                
            } else {
                fadeOutCenter = CGPointMake(  -(self.center.x)
                                            , self.center.y);
            }
            break;

        default:
            break;
    }
    
#warning hardcoded
    [UIView animateWithDuration:2.0 animations:^{
        [self setCenter:fadeOutCenter];
    } completion:^(BOOL finished) {
        NSLog(@"add callback for delegate here");
    }];
}

#pragma mark -
#pragma mark Dismiss methods

- (void)addDismissMethod {
    // Adding swipe to dismiss if setted
    UISwipeGestureRecognizer *dismissGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewWithGesture:)];

    switch (self.position) {
        case MessageBannerPositionTop:
            [dismissGesture setDirection:UISwipeGestureRecognizerDirectionUp];;
            break;
        case MessageBannerPositionBottom:
            [dismissGesture setDirection:UISwipeGestureRecognizerDirectionDown];
            break;
        case MessageBannerPositionCenter: {
            [dismissGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
            UISwipeGestureRecognizer *dismissGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewWithGesture:)];
            [dismissGesture2 setDirection:UISwipeGestureRecognizerDirectionRight];
            [self addGestureRecognizer:dismissGesture2];
            break;
        }
        default:
            
            break;
    }
    [self addGestureRecognizer:dismissGesture];
    
    UITapGestureRecognizer *dismissGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewWithGesture:)];
    [dismissGesture3 setNumberOfTapsRequired:1];
    [self addGestureRecognizer:dismissGesture3];
}

#pragma mark -
#pragma mark View frame methods
- (CGRect) createViewFrame {
    CGRect viewFrame;
    
    switch (self.position) {
        case MessageBannerPositionTop:
            
            
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            viewFrame = CGRectMake(  0
                                   , 0 - self.messageViewHeight
                                   , self.viewController.view.bounds.size.width
                                   , self.messageViewHeight);
            break;
            
        case MessageBannerPositionBottom:
            
            self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
            viewFrame = CGRectMake(  0
                                   , self.viewController.view.bounds.size.height + self.messageViewHeight
                                   , self.viewController.view.bounds.size.width
                                   , self.messageViewHeight);
            break;
            
        case MessageBannerPositionCenter:
            
            self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
            viewFrame = CGRectMake(  -(self.viewController.view.bounds.size.width)
                                   , ((self.viewController.view.bounds.size.height / 2.0f) - (self.messageViewHeight / 2.0f))
                                   , self.viewController.view.bounds.size.width
                                   , self.messageViewHeight);
            break;
            
        default:
            break;
    }
    return viewFrame;
}

#pragma mark -
#pragma mark Title Label methods

- (UILabel *)createMessageTitle {
    UILabel *titleLabel = [[UILabel alloc] init];
    
//    Adding title
    [titleLabel setText:self.title];
    
//    Changing text appearance
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    // set new font and size text later
    // set shadow ?
    
//    title formating
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    return (titleLabel);
}

- (void)setTitleFrame:(UILabel *)titleView {
    CGFloat parentViewWidth = self.viewController.view.bounds.size.width;
    CGFloat leftOffset = ELEMENTS_PADDING;
    
//     If image then offset the text more
    if (self.image != nil) {
        leftOffset += (self.image.size.width + (2 * ELEMENTS_PADDING));
    }

    [titleView setFrame:CGRectMake(  leftOffset
                                   , ELEMENTS_PADDING
                                   , parentViewWidth - ELEMENTS_PADDING
                                   , 0.0f
                                   )];
    
// updating height
    [titleView sizeToFit];
    
//    updating viewHeight
    self.messageViewHeight += (titleView.frame.origin.y + titleView.frame.size.height);
}

#pragma mark -
#pragma mark Subtitle Label methods

- (UILabel *)createSubtitleLabel {
    UILabel *subtitleLabel = [[UILabel alloc] init];
    
    //    Adding subtitle
    [subtitleLabel setText:self.subTitle];
    
    //    Changing text appearance
    [subtitleLabel setBackgroundColor:[UIColor clearColor]];
    
    [subtitleLabel setTextColor:[UIColor grayColor]];
    [subtitleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    // set new font and size text later
    // set shadow ?
    
    //    subtitle formating
    [subtitleLabel setNumberOfLines:0];
    [subtitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    return (subtitleLabel);
}

- (void)setSubtitleFrame:(UILabel *)subtitleView {
    CGFloat leftOffset = ELEMENTS_PADDING;
    
//         If image then offset the text more
    if (self.image != nil) {
        leftOffset += (self.image.size.width + (2 * ELEMENTS_PADDING));
    }
    
    [subtitleView setFrame:CGRectMake(  leftOffset
                                      , (ELEMENTS_PADDING + self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height)
                                      , self.viewController.view.bounds.size.width - ELEMENTS_PADDING
                                      , 0.0f
                                      )];
//   updating height
    [subtitleView sizeToFit];
    
//    updating viewHeight
    self.messageViewHeight += (subtitleView.frame.origin.y + subtitleView.frame.size.height);
}

#pragma mark -
#pragma mark Swipe Gesture Reconiser handler methods

- (void) UserSwippedViewWith:(UISwipeGestureRecognizer *)swipeRecognizer {
    [self dismissViewWithGesture:swipeRecognizer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
