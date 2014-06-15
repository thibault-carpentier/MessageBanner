/**
 * @file   MessageBanneviewr.m
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MessageBannerView popup flat styled view.
 *
 * MessageBannerView a customisable popupview
 */

#import "MessageBannerView.h"
#import "MessageBanner.h"
#import "HexColor.h"
#import "FXBlurView.h"
/**
 The default design file
 */
#define DEFAULT_DESIGN_FILE                 @"MessageBannerDesign.json"

/**
 The label of the error type message banner configuration
 */
#define ERROR_JSON_LABEL                    @"Error"
/**
 The label of the warning type message banner configuration
 */
#define WARNING_JSON_LABEL                  @"Warning"
/**
 The label of the message type message banner configuration
 */
#define MESSAGE_JSON_LABEL                  @"Message"
/**
 The label of the success type message banner configuration
 */
#define SUCCESS_JSON_LABEL                  @"Success"

/**
 The blur radius key in the design configuration file
 */
#define BLUR_RADIUS_KEY                     @"blurRadius"

/**
 The background color key in the design configuration file
 */
#define BACKGROUND_COLOR_KEY                @"backgroundColor"
/**
 The backgorund alpha key in the design configuration file
 */
#define BACKGROUND_ALPHA_KEY                @"backgroundAlpha"
/**
 The  background image key in the design configuration file
 */
#define BACKGROUND_IMAGE_KEY                @"backgroundImageName"

/**
 The  default left image for the type in the design configuration file
 */
#define DEFAULT_TYPE_IMAGE_KEY              @"defaultImageForType"

/**
 The title text size key in the design configuration file
 */
#define TITLE_TEXT_SIZE_KEY                 @"titleTextSize"
/**
 The title text color key in the design configuration file
 */
#define TITLE_TEXT_COLOR_KEY                @"titleTextColor"
/**
 The title text shadow color key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_COLOR_KEY         @"titleTextShadowColor"
/**
 The title text shadow X offset key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_OFFSET_X_KEY      @"titleTextShadowOffsetX"
/**
 The title text shadow Y offset key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_OFFSET_Y_KEY      @"titleTextShadowOffsetY"
/**
 The the title text shadow alpha key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_ALPHA_KEY         @"titleTextShadowAlpha"

/**
 The subtitle text size key in the design configuration file
 */
#define SUBTITLE_TEXT_SIZE_KEY              @"subtitleTextSize"
/**
 The subtitle text color key in the design configuration file
 */
#define SUBTITLE_TEXT_COLOR_KEY             @"subtitleTextColor"
/**
 The subtitle text shadow color key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_COLOR_KEY      @"subtitleTextShadowColor"
/**
 The subtitle text shadow X offset key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_OFFSET_X_KEY   @"subtitleTextShadowOffsetX"
/**
 The subtitle text shadow Y offset key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_OFFSET_Y_KEY   @"subtitleTextShadowOffsetY"
/**
 The subtitle text shadow alpha key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_ALPHA_KEY      @"subtitleTextShadowAlpha"

/**
 The button background color key in the design configuration file
 */
#define BUTTON_BACKGROUND_COLOR_KEY         @"buttonBackgroundColor"
/**
 The button background image key in the design configuration file
 */
#define BUTTON_BACKGROUND_IMAGE_KEY         @"buttonBackgroundImage"
/**
 The button image pattern background key in the design configuration file
 */
#define BUTTON_BACKGROUND_PATTERN_IMAGE_KEY @"buttonBackgroundPatternImage"
/**
 The button background alpha key in the design configuration file
 */
#define BUTTON_BACKGROUND_ALPHA_KEY         @"buttonBackgroundAlpha"

/**
 The button corener radius key in the design configuration file
 */
#define BUTTON_CORNER_RADIUS_KEY            @"buttonCornerRadius"
/**
 The button border color key in the design configuration file
 */
#define BUTTON_BORDER_COLOR_KEY             @"buttonBorderColor"
/**
 The button border alpha key in the design configuration file
 */
#define BUTTON_BORDER_ALPHA_KEY             @"buttonBorderAlpha"
/**
 The button border size key in the design configuration file
 */
#define BUTTON_BORDER_SIZE_KEY              @"buttonBorderSize"

/**
 The button text color key in the design configuration file
 */
#define BUTTON_TEXT_COLOR_KEY               @"buttonTextColor"
/**
 The button text shadow color key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_COLOR_KEY        @"buttonTextShadowColor"
/**
 The button text shadow X offset key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_OFFSET_X_KEY     @"buttonTextShadowOffsetX"
/**
 The button text shadow Y offset key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_OFFSET_Y_KEY     @"buttonTextShadowOffsetY"
/**
 The button text shadow alpha key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_ALPHA_KEY        @"buttonTextShadowAlpha"

/**
 The default element padding used for positionning
 */
#define ELEMENTS_PADDING                    16.0f

/**
 The animation duration used for setting the blur
 */
#define ANIMATION_DURATION                  0.5

/**
 Undocumented private methods calls for internal use
 */
@interface MessageBanner (MessageBannerView)
    - (void) hideMessageBanner:(MessageBannerView *)messageBanner
                   withGesture:(UIGestureRecognizer *)gesture
                 andCompletion:(void (^)())completion;

@end

/**
 General banner design
 */
static NSMutableDictionary* _messageBannerDesign;

@interface MessageBannerView ()

/**
 The title label view
 */
@property (nonatomic, strong) UILabel*      titleLabel;
/**
 The subtitle label view
 */
@property (nonatomic, strong) UILabel*      subtitleLabel;
/**
 The image view
 */
@property (nonatomic, strong) UIImageView*  imageView;
/**
 The button view
 */
@property (nonatomic, strong) UIButton*     button;
/**
 The blurr view attached to the viewcontroller if activated
 */
@property (nonatomic, strong) FXBlurView*   blurView;
/**
 The message view height used for calculs
 */
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
        if (self.subTitle) {
            self.subtitleLabel = [self createSubtitleLabel];
            [self addSubview:self.subtitleLabel];
        }

        // Setting up style
        [self setupStyleWithType:self.bannerType];
        
        //        Setting up frames
        [self setTitleFrame:self.titleLabel];
        if (self.subTitle) {
            [self setSubtitleFrame:self.subtitleLabel];
        }
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
    
    [self setupViewsAutoLayout];
    
    return self;
}

#pragma mark -
#pragma mark Autolayout methods

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void)setupTitleAutoLayout {
//    NSDictionary *titleAndViewDictionary = NSDictionaryOfVariableBindings (_titleLabel, self);
//    NSDictionary *titleAndImageDictionary = (self.image ? NSDictionaryOfVariableBindings (self.titleLabel, self.image) : nil);
//    NSDictionary *titleAndButtonDictionary = (self.button ? NSDictionaryOfVariableBindings (self.titleLabel, self.button) : nil);
//    NSDictionary *titleAndSubtitleDictionary = (self.subtitleLabel ? NSDictionaryOfVariableBindings (self.titleLabel, self.subTitle) : nil);
//    
//    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    if (self.subtitleLabel) {
//        [self addConstraint:
//         [NSLayoutConstraint constraintWithItem:self.titleLabel
//                                  attribute:NSLayoutAttributeWidth
//                                  relatedBy:NSLayoutRelationEqual
//                                     toItem:self.subtitleLabel
//                                  attribute:NSLayoutAttributeWidth
//                                 multiplier:1.0f
//                                   constant:0.0f]];
//    }
//    NSString *topConstraintVisualFormat = [NSString stringWithFormat:@"V:|-%f-[_titleLabel]|", ELEMENTS_PADDING];
//    [self addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:topConstraintVisualFormat options:0 metrics:nil views:titleAndViewDictionary]];
}

- (void)setupViewsAutoLayout {
//    [self setupTitleAutoLayout];
    
    NSString* heightConstraintVisualFormat = [NSString stringWithFormat:@"H:[self(>=%f)]", self.viewController.view.frame.size.width];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:heightConstraintVisualFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(self)]];
 
    NSString* widthConstraintVisualFormat = [NSString stringWithFormat:@"V:[self(>=%f)]", self.messageViewHeight];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:widthConstraintVisualFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(self)]];
    
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
#pragma mark View Management

- (void)setBlur {
    CGFloat blurRadius = [[_currentDesign objectForKey:BLUR_RADIUS_KEY] floatValue];
    
    if (blurRadius != 0.0) {
        self.blurView = [[FXBlurView alloc] initWithFrame:self.viewController.view.bounds];
        self.blurView.underlyingView = self.viewController.view;
        self.blurView.tintColor = [UIColor clearColor];
        self.blurView.blurRadius = blurRadius;
        self.blurView.alpha = 0.f;
        
        if ([self.viewController isKindOfClass:[UINavigationController class]] || [self.viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
            
            if ([self.viewController isKindOfClass:[UINavigationController class]]) {
                [((UINavigationController *)self.viewController).view insertSubview:self.blurView
                                                                       belowSubview:[((UINavigationController *)self.viewController) navigationBar]];
            } else {
                [((UINavigationController *)self.viewController.parentViewController).visibleViewController.view addSubview:self.blurView];
            }
        }
        else {
            [self.viewController.view addSubview:self.blurView];
        }
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.blurView.alpha = 1.f;
        } completion:nil];
    }
}

- (void)unsetBlur {
     CGFloat blurRadius = [[_currentDesign objectForKey:BLUR_RADIUS_KEY] floatValue];
    
    if (blurRadius != 0.0) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.blurView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.blurView removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark View frame methods
- (CGRect) createViewFrame {
    CGRect viewFrame;
    
    // Adding Bottom padding
    self.messageViewHeight += ELEMENTS_PADDING;
    
    switch (self.position) {
        case MessageBannerPositionTop: {
            
            
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            viewFrame = CGRectMake(  0
                                   , 0 - self.messageViewHeight
                                   , self.viewController.view.bounds.size.width
                                   , self.messageViewHeight);
            break;
        }
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
    
    // Used to add constraints  when the view will pop
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
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
