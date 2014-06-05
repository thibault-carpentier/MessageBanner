//
//  MessageBannerView.m
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import "MessageBannerView.h"
#import "MessageBanner.h"
#import "HexColor.h"


#define DEFAULT_DESIGN_FILE                 @"MessageBannerDesign.json"

#define ERROR_JSON_LABEL                    @"Error"
#define WARNING_JSON_LABEL                  @"Warning"
#define MESSAGE_JSON_LABEL                  @"Message"
#define SUCCESS_JSON_LABEL                  @"Success"

#define BACKGROUND_COLOR_KEY                @"backgroundColor"
#define BACKGROUND_ALPHA_KEY                @"backgroundAlpha"
#define BACKGROUND_IMAGE_KEY                @"backgroundImageName"

#define DEFAULT_TYPE_IMAGE_KEY              @"defaultImageForType"

#define TITLE_TEXT_SIZE_KEY                 @"titleTextSize"
#define TITLE_TEXT_COLOR_KEY                @"titleTextColor"
#define TITLE_TEXT_SHADOW_COLOR_KEY         @"titleTextShadowColor"
#define TITLE_TEXT_SHADOW_OFFSET_X_KEY      @"titleTextShadowOffsetX"
#define TITLE_TEXT_SHADOW_OFFSET_Y_KEY      @"titleTextShadowOffsetY"
#define TITLE_TEXT_SHADOW_ALPHA_KEY         @"titleTextShadowAlpha"

#define SUBTITLE_TEXT_SIZE_KEY              @"subtitleTextSize"
#define SUBTITLE_TEXT_COLOR_KEY             @"subtitleTextColor"
#define SUBTITLE_TEXT_SHADOW_COLOR_KEY      @"subtitleTextShadowColor"
#define SUBTITLE_TEXT_SHADOW_OFFSET_X_KEY   @"subtitleTextShadowOffsetX"
#define SUBTITLE_TEXT_SHADOW_OFFSET_Y_KEY   @"subtitleTextShadowOffsetY"
#define SUBTITLE_TEXT_SHADOW_ALPHA_KEY      @"subtitleTextShadowAlpha"

#define BUTTON_BACKGROUND_COLOR_KEY         @"buttonBackgroundColor"
#define BUTTON_BACKGROUND_IMAGE_KEY         @"buttonBackgroundImage"
#define BUTTON_BACKGROUND_PATTERN_IMAGE_KEY @"buttonBackgroundPatternImage"
#define BUTTON_BACKGROUND_ALPHA_KEY         @"buttonBackgroundAlpha"

#define BUTTON_CORNER_RADIUS_KEY            @"buttonCornerRadius"
#define BUTTON_BORDER_COLOR_KEY             @"buttonBorderColor"
#define BUTTON_BORDER_ALPHA_KEY             @"buttonBorderAlpha"
#define BUTTON_BORDER_SIZE_KEY              @"buttonBorderSize"

#define BUTTON_TEXT_COLOR_KEY               @"buttonTextColor"
#define BUTTON_TEXT_SHADOW_COLOR_KEY        @"buttonTextShadowColor"
#define BUTTON_TEXT_SHADOW_OFFSET_X_KEY     @"buttonTextShadowOffsetX"
#define BUTTON_TEXT_SHADOW_OFFSET_Y_KEY     @"buttonTextShadowOffsetY"
#define BUTTON_TEXT_SHADOW_ALPHA_KEY        @"buttonTextShadowAlpha"


#define ELEMENTS_PADDING                    16.0f


@interface MessageBanner (MessageBannerView)
    - (void) hideMessageBanner:(MessageBannerView *)messageBanner
                   withGesture:(UIGestureRecognizer *)gesture
                 andCompletion:(void (^)())completion; // use private call of MessageBanner
@end

static NSMutableDictionary* _messageBannerDesign;

@interface MessageBannerView ()

@property (nonatomic, strong) UILabel*      titleLabel;
@property (nonatomic, strong) UILabel*      subtitleLabel;
@property (nonatomic, strong) UIImageView*  imageView;
@property (nonatomic, strong) UIButton*     button;

@property (nonatomic, assign) CGFloat  messageViewHeight;

@end

@implementation MessageBannerView

#pragma mark -
#pragma mark Message Banner Design File Methods

+ (BOOL)addMessageBannerDesignFromFileNamed:(NSString *)file {
    BOOL success = YES;
    NSError* error;
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];
    NSDictionary* newDesign = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                              options:kNilOptions
                                                                error:&error];
    if (error) {
        success = NO;
        @throw ([NSException exceptionWithName:@"Error loading design" reason:[NSString stringWithFormat:@"Can not load %@.\nError:%@", file, error] userInfo:nil]);
    } else {
        [[MessageBannerView messageBannerDesign] addEntriesFromDictionary:newDesign];
    }
    return success;
}

+ (NSMutableDictionary *)messageBannerDesign {
    if (!_messageBannerDesign) {
        NSError* error;
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DEFAULT_DESIGN_FILE];
        _messageBannerDesign = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:&error];
        
        if (error) {
            @throw ([NSException exceptionWithName:@"Error loading default design" reason:[NSString stringWithFormat:@"Can not load %@.\nError:%@", DEFAULT_DESIGN_FILE, error] userInfo:nil]);
        }
    }
    return _messageBannerDesign;
}

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

        _currentDesign = [[MessageBannerView messageBannerDesign] objectForKey:[self getStyleTypeLabel:self.bannerType]];
        // Adding Default Image from config
        if (_image == nil) {
            _image = [UIImage imageNamed:[_currentDesign objectForKey:DEFAULT_TYPE_IMAGE_KEY]];
        }
        
        
        
        // To be declined according to position;
        
        [self addButtonOnBannerAndSetupFrame:buttonTitle];
        //        Setting up title
        self.titleLabel = [self createMessageTitle];
        [self addSubview:self.titleLabel];
        
        //        Setting up subtitle
        self.subtitleLabel = [self createSubtitleLabel];
        [self addSubview:self.subtitleLabel];

        // Setting up style
        [self setupStyleWithType:self.bannerType];
        
        //        Setting up frames
        [self setTitleFrame:self.titleLabel];
        [self setSubtitleFrame:self.subtitleLabel];
        [self addImageOnBannerAndSetupFrame:self.image];
        [self centerButton];
        //        [self setImageFrame:image]
        
        //        Setting message frame :
        [self setFrame:[self createViewFrame]];
        

        
        
        
        //        Adding dismiss gesture
        if (self.userDismissEnabled) {
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
        leftOffset += (self.image.size.width + (ELEMENTS_PADDING));
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
        leftOffset += (self.image.size.width + (ELEMENTS_PADDING));
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
    self.imageView.frame = CGRectMake(ELEMENTS_PADDING,
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
        
        [self addSubview:self.button];
    }
}

- (void)centerButton {
    self.button.center = CGPointMake(  self.button.center.x
                                     , ((self.messageViewHeight + ELEMENTS_PADDING) / 2.0f));
}

#pragma mark -
#pragma mark View Cosmetic
-(NSString *)getStyleTypeLabel:(MessageBannerType)bannerType {
    NSString* styleLabel;
    
    switch (bannerType) {
        case MessageBannerTypeError:
            styleLabel = ERROR_JSON_LABEL;
            break;
        case MessageBannerTypeWarning:
            styleLabel = WARNING_JSON_LABEL;
            break;
        case MessageBannerTypeMessage:
            styleLabel = MESSAGE_JSON_LABEL;
            break;
        case MessageBannerTypeSuccess:
            styleLabel = SUCCESS_JSON_LABEL;
            break;
        default:
            styleLabel = MESSAGE_JSON_LABEL;
            break;
    }
    return styleLabel;
}

- (void) setupStyleWithType:(MessageBannerType)bannerType {
     [self applyMessageStyleFromDictionnary:_currentDesign];
}

- (void)applyMessageStyleFromDictionnary:(NSDictionary *)messageStyle {

    [self setBackgroundColor:[UIColor colorWithHexString:[messageStyle objectForKey:BACKGROUND_COLOR_KEY] alpha:[[messageStyle objectForKey:BACKGROUND_ALPHA_KEY] floatValue]]];
    if ([messageStyle objectForKey:BACKGROUND_IMAGE_KEY] && [UIImage imageNamed:[messageStyle objectForKey:BACKGROUND_IMAGE_KEY]]) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[messageStyle objectForKey:BACKGROUND_IMAGE_KEY]]]];
        [self setAlpha:[[messageStyle objectForKey:BACKGROUND_ALPHA_KEY] floatValue]];
    }
    
    
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[[messageStyle valueForKey:TITLE_TEXT_SIZE_KEY] floatValue]]];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:[messageStyle objectForKey:TITLE_TEXT_COLOR_KEY]]];
    [self.titleLabel setShadowColor:[UIColor colorWithHexString:[messageStyle objectForKey:TITLE_TEXT_SHADOW_COLOR_KEY] alpha:[[messageStyle objectForKey:TITLE_TEXT_SHADOW_ALPHA_KEY] floatValue]]];
    [self.titleLabel setShadowOffset:CGSizeMake([[messageStyle objectForKey:TITLE_TEXT_SHADOW_OFFSET_X_KEY] floatValue],
                                                 [[messageStyle objectForKey: TITLE_TEXT_SHADOW_OFFSET_Y_KEY] floatValue])];

    
    [self.subtitleLabel setFont:[UIFont systemFontOfSize:[[messageStyle valueForKey:SUBTITLE_TEXT_SIZE_KEY] floatValue]]];
    [self.subtitleLabel setTextColor:[UIColor colorWithHexString:[messageStyle objectForKey:SUBTITLE_TEXT_COLOR_KEY]]];
    [self.subtitleLabel setShadowColor:[UIColor colorWithHexString:[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_COLOR_KEY] alpha:[[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_ALPHA_KEY] floatValue]]];
    [self.subtitleLabel setShadowOffset:CGSizeMake([[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_OFFSET_X_KEY] floatValue],
                                                [[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_OFFSET_Y_KEY] floatValue])];
    
    

    [self.button setTitleColor:[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_TEXT_COLOR_KEY]] forState:UIControlStateNormal];
    [self.button setTitleShadowColor:[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_TEXT_SHADOW_COLOR_KEY] alpha:[[messageStyle objectForKey:BUTTON_TEXT_SHADOW_ALPHA_KEY] floatValue]] forState:UIControlStateNormal];
    [self.button.titleLabel setShadowOffset:CGSizeMake([[messageStyle objectForKey:BUTTON_TEXT_SHADOW_OFFSET_X_KEY] floatValue],
                                                      [[messageStyle objectForKey:BUTTON_TEXT_SHADOW_OFFSET_Y_KEY] floatValue])];
    
    
    [self.button setBackgroundColor:[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_BACKGROUND_COLOR_KEY] alpha:[[messageStyle objectForKey:BUTTON_BACKGROUND_ALPHA_KEY] floatValue]]];
    
    if ([messageStyle objectForKey:BUTTON_BACKGROUND_IMAGE_KEY] != nil &&
        [UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_IMAGE_KEY]] != nil) {
        [self.button setBackgroundImage:[UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_IMAGE_KEY]] forState:UIControlStateNormal];
        [self.button setAlpha:[[messageStyle objectForKey:BUTTON_BACKGROUND_ALPHA_KEY] floatValue]];
    }
    if ([messageStyle objectForKey:BUTTON_BACKGROUND_PATTERN_IMAGE_KEY] != nil &&
        [UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_PATTERN_IMAGE_KEY]] != nil) {
        [self.button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_PATTERN_IMAGE_KEY]]]];
        [self.button setAlpha:[[messageStyle objectForKey:BUTTON_BACKGROUND_ALPHA_KEY] floatValue]];
    }
    [self.button.layer setCornerRadius:[[messageStyle objectForKey:BUTTON_CORNER_RADIUS_KEY] floatValue]];
    [self.button.layer setMasksToBounds:YES];
    
    [self.button.layer setBorderColor:[[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_BORDER_COLOR_KEY] alpha:[[messageStyle objectForKey:BUTTON_BORDER_ALPHA_KEY] floatValue]] CGColor]];
    [self.button.layer setBorderWidth:[[messageStyle objectForKey:BUTTON_BORDER_SIZE_KEY] floatValue]];
    
    
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
