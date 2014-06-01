//
//  MessageBannerView.m
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import "MessageBannerView.h"
#import "MessageBanner.h"


#define ELEMENTS_PADDING 16.0f

@interface MessageBanner (MessageBannerView)
    - (void) hideMessageBanner:(MessageBannerView *)messageBanner
                   withGesture:(UIGestureRecognizer *)gesture
                 andCompletion:(void (^)())completion; // use private call of MessageBanner
@end

@interface MessageBannerView ()

@property (nonatomic, strong) UILabel*      titleLabel;
@property (nonatomic, strong) UILabel*      subtitleLabel;
@property (nonatomic, strong) UIImageView*  imageView;
@property (nonatomic, strong) UIButton*     button;

@property (nonatomic, assign) CGFloat  messageViewHeight;

@end

@implementation MessageBannerView

#pragma mark -
#pragma mark Init and dismiss methods

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              image:(UIImage *)image
               type:(MessageBannerType)bannerType
           duration:(CGFloat)duration
   inViewController:(UIViewController *)viewController
           userDissmissedCallback:(void (^)(MessageBannerView* banner))userDissmissedCallback
        buttonTitle:(NSString *)buttonTitle
     userPressedButtonCallback:(void (^)(MessageBannerView* banner))userPressedButtonCallback
         atPosition:(MessageBannerPosition)position
canBeDismissedByUser:(BOOL)dismissingEnabled {
   
    if ((self = [self init])) {
        
        _titleBanner = title;
        _subTitle = subtitle;
        _image = image;
        _bannerType = bannerType;
        _duration = duration;
        _viewController = viewController;
        _userDissmissedCallback = userDissmissedCallback;
        _buttonTitle = buttonTitle;
        _userPressedButtonCallback = userPressedButtonCallback;
        
        _position = position;
        _userDismissEnabled = dismissingEnabled;
        
        self.messageViewHeight = 0.0f;
        _isBannerDisplayed = NO;
        
        // To be declined according to position;
        
        [self addButtonOnBannerAndSetupFrame:buttonTitle];
        //        Setting up title
        self.titleLabel = [self createMessageTitle];
        [self addSubview:self.titleLabel];
        
        //        Setting up subtitle
        self.subtitleLabel = [self createSubtitleLabel];
        [self addSubview:self.subtitleLabel];

        
        //        Setting up frames
        [self setTitleFrame:self.titleLabel];
        [self setSubtitleFrame:self.subtitleLabel];
        [self addImageOnBannerAndSetupFrame:image];
        [self centerButton];
        //        [self setImageFrame:image]
        
        //        Setting message frame :
        [self setFrame:[self createViewFrame]];
        
    	[self setupStyleWithType:bannerType];
        
        
        
        //        Adding dismiss gesture
        if (dismissingEnabled) {
            [self addDismissMethod];
        }
    }
    return self;
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
    
    // Adding Bottom padding
    self.messageViewHeight += ELEMENTS_PADDING;
    
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
    [titleLabel setText:self.titleBanner];
    
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
    CGFloat leftOffset = ELEMENTS_PADDING;
    CGFloat rightOffset = ELEMENTS_PADDING;
    
    //     If image then offset the text more
    if (self.image != nil) {
        leftOffset += (self.image.size.width + (2 * ELEMENTS_PADDING));
    }
    
    if (self.buttonTitle && [self.buttonTitle length]) {
        rightOffset += self.button.frame.size.width + ELEMENTS_PADDING;
    }
    
    
    [titleView setFrame:CGRectMake(  leftOffset
                                   , ELEMENTS_PADDING
                                   , self.viewController.view.bounds.size.width - leftOffset - rightOffset
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
    CGFloat rightOffset = ELEMENTS_PADDING;
    
    //         If image then offset the text more
    if (self.image != nil) {
        leftOffset += (self.image.size.width + (2 * ELEMENTS_PADDING));
    }
    
    if (self.buttonTitle && [self.buttonTitle length]) {
        rightOffset += self.button.frame.size.width + ELEMENTS_PADDING;
    }
    
    [subtitleView setFrame:CGRectMake(  leftOffset
                                      , (ELEMENTS_PADDING + self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height)
                                      , self.viewController.view.bounds.size.width - leftOffset - rightOffset
                                      , 0.0f
                                      )];
    //   updating height
    [subtitleView sizeToFit];
    
    //    updating viewHeight
    self.messageViewHeight += (subtitleView.frame.origin.y - self.messageViewHeight) + subtitleView.frame.size.height;
}

#pragma mark -
#pragma mark Image View methods

- (void)addImageOnBannerAndSetupFrame:(UIImage *)image {
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(ELEMENTS_PADDING * 2,
                                      ((ELEMENTS_PADDING +  self.messageViewHeight - image.size.height) /2),
                                      image.size.width,
                                      image.size.height);
    
    [self addSubview:self.imageView];
}

#pragma mark -
#pragma mark Button methods Button View methods

- (void)addButtonOnBannerAndSetupFrame:(NSString *)buttonTitle {
    
    if (buttonTitle && [buttonTitle length]) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:buttonTitle forState:UIControlStateNormal];
        [self.button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        self.button.contentEdgeInsets = UIEdgeInsetsMake(  0.0f
                                                         , 5.0f
                                                         , 0.0f
                                                         , 5.0f);
        [self.button sizeToFit];
        self.button.frame = CGRectMake((self.viewController.view.frame.size.width - ELEMENTS_PADDING - self.button.frame.size.width)
                                       , 0.0
                                       , self.button.frame.size.width
                                       , 32.0);
        if (self.userPressedButtonCallback) {
            [self.button addTarget:self action:@selector(userDidPressedButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
#warning to Remove
        self.button.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:self.button];
    }
}

- (void)centerButton {
    self.button.center = CGPointMake(  self.button.center.x
                                     , ((self.messageViewHeight + ELEMENTS_PADDING) / 2.0f));
}

#pragma mark -
#pragma mark View Cosmetic
- (void) setupStyleWithType:(MessageBannerType)bannerType {
    
    switch (bannerType) {
        case MessageBannerTypeError:
            self.backgroundColor = [UIColor redColor];
            break;
        case MessageBannerTypeWarning:
            self.backgroundColor = [UIColor yellowColor];
            break;
        case MessageBannerTypeMessage:
            self.backgroundColor = [UIColor grayColor];
            break;
        case MessageBannerTypeSuccess:
            self.backgroundColor = [UIColor greenColor];
            break;
        default:
            self.backgroundColor = [UIColor blueColor];
            break;
    }
}

#pragma mark -
#pragma mark Swipe Gesture Reconizer handler methods

-(void)dismissViewWithGesture:(UIGestureRecognizer*)gesture {
    
    if (self.isBannerDisplayed == YES) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.userDissmissedCallback) {
                self.userDissmissedCallback(self);
            }
            [[MessageBanner sharedSingleton] hideMessageBanner:self withGesture:gesture andCompletion:nil];
        });
        
    }
}

#pragma mark - Button Pressed Gesture Recognizer methods

- (void)userDidPressedButton:(UIButton *)sender {
    (void)sender;
    if (self.userPressedButtonCallback) {
        self.userPressedButtonCallback(self);
    }
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
