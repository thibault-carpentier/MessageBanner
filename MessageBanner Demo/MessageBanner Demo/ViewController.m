//
//  ViewController.m
//  MessageBanner
//
//  Created by Thibault Carpentier on 4/22/14.
//  Copyright (c) 2014 Thibault Carpentier. All rights reserved.
//

#import "ViewController.h"
#import "MessageBannerView.h"

@interface ViewController ()

@property (nonatomic, assign) MessageBannerPosition messagePosition;
@property (nonatomic, assign) MessageBannerType     messageType;
@property (nonatomic, copy)   NSString*             bannerTitle;
@property (nonatomic, copy)   NSString*             subTitle;
@property (nonatomic, copy)   UIImage*              image;
@property (nonatomic, assign) CGFloat               duration;
@property (nonatomic, assign) BOOL                  userDismissEnabled;
@property (nonatomic, copy)   NSString*             buttonTitle;

@property (weak, nonatomic) IBOutlet UISegmentedControl* userDismissSegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider*      durationSlider;
@property (weak, nonatomic) IBOutlet UILabel*       durationLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bannerTitle = @"Small title.";
    self.subTitle = @"Small subtitle.";
    self.image = nil;
    self.duration = MessageBannerDurationDefault;
    self.messageType = MessageBannerTypeError;
    self.messagePosition = MessageBannerPositionTop;
    self.userDismissEnabled = YES;
    self.buttonTitle = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBannerViewWillAppearNotification:) name:MESSAGE_BANNER_VIEW_WILL_APPEAR_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBannerViewDidAppearNotification:) name:MESSAGE_BANNER_VIEW_DID_APPEAR_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBannerViewWillDisappearNotification:) name:MESSAGE_BANNER_VIEW_WILL_DISAPPEAR_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBannerViewDidDisappearNotification:) name:MESSAGE_BANNER_VIEW_DID_DISAPPEAR_NOTIFICATION object:nil];
}

#pragma mark -
#pragma mark MessageBanner delegate methods

- (void)messageBannerViewWillAppear:(MessageBannerView *)messageBanner {
    NSLog(@"MessageBanner [WILL APPEAR]");
}

- (void)messageBannerViewDidAppear:(MessageBannerView *)messageBanner {
    NSLog(@"MessageBanner [DID APPEAR]");
}

- (void)messageBannerViewWillDisappear:(MessageBannerView *)messageBanner {
    NSLog(@"MessageBanner [WILL DISAPPEAR]");
}

- (void)messageBannerViewDidDisappear:(MessageBannerView *)messageBanner {
    NSLog(@"MessageBanner [DID DISAPPEAR]");
}

#pragma mark -
#pragma mark MessageBanner notification methods

- (void)messageBannerViewWillAppearNotification:(MessageBannerView *)messageBanner {
    NSLog(@"NOTIFICATION => MessageBanner [WILL APPEAR]");
}

- (void)messageBannerViewDidAppearNotification:(MessageBannerView *)messageBanner {
    NSLog(@"NOTIFICATION => MessageBanner [DID APPEAR]");
}

- (void)messageBannerViewWillDisappearNotification:(MessageBannerView *)messageBanner {
    NSLog(@"NOTIFICATION => MessageBanner [WILL DISAPPEAR]");
}

- (void)messageBannerViewDidDisappearNotification:(MessageBannerView *)messageBanner {
    NSLog(@"NOTIFICATION => MessageBanner [DID DISAPPEAR]");
}


#pragma mark -
#pragma mark ConvertionMethods

- (NSString *)getTypeDescription:(MessageBannerType)bannerType {
    NSString* result;
    
    switch (bannerType) {
        case MessageBannerTypeError: {
            result = @"Message Banner Error";
            break;
        }
        case MessageBannerTypeWarning: {
            result = @"Message Banner Warning";
            break;
        }
        case MessageBannerTypeMessage: {
            result = @"Message Banner Message";
            break;
        }
        case MessageBannerTypeSuccess: {
            result = @"Message Banner Success";
            break;
        }
            
        default:
            result = @"Unknow Message Banner type";
            break;
    }
    return result;
}

- (NSString *)getPositionDescription:(MessageBannerPosition)bannerPosition {
    NSString* result;
    switch (bannerPosition) {
        case MessageBannerPositionBottom: {
            result = @"Message Banner Bottom";
            break;
        }
        case MessageBannerPositionCenter: {
            result = @"Message Banner Middle";
            break;
        }
        case MessageBannerPositionTop: {
            result = @"Message Banner Top";
            break;
        }
            
        default: {
            result = @"Unknow Message Banner position";
            break;
        }
    }
    return result;
}

#pragma mark -
#pragma mark NavBar Buttons

- (IBAction)toggleNavBar:(id)sender {
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    self.navigationController.toolbarHidden = !self.navigationController.toolbarHidden;
}

#pragma mark -
#pragma mark Popup buttons

- (IBAction)popMeOne:(id)sender {
    
    
//    [MessageBanner setMessageBannerDelegate:self];
    
    [MessageBanner showMessageBannerInViewController:self
                                              title:self.bannerTitle
                                           subtitle:self.subTitle
                                              image:self.image
                                               type:self.messageType
                                           duration:self.duration
                                           userDissmissedCallback:^(MessageBannerView* message) {
                                               NSLog(@"Banner with :\n{\n"
                                                     "Title: [%@]\n"
                                                     "Subtitle: [%@]\n"
                                                     "Image: [%@]\n"
                                                     "Type: [%@]\n"
                                                     "Duration: [%f]\n"
                                                     "Position: [%@]\n"
                                                     "User interaction allowed: [%@]\n"
                                                     "}\n has been [DISMISSED]."
                                                     , message.titleBanner
                                                     , message.subTitle
                                                     , (message.image ? @"Icon setted" : @"No icon setted")
                                                     , [self getTypeDescription:message.bannerType]
                                                     , message.duration
                                                     , [self getPositionDescription:message.position]
                                                     , (message.userDismissEnabled ? @"YES" : @"NO")
                                                     );
                                               
                                               return ;
                                           }
                                         buttonTitle:self.buttonTitle
                                     userPressedButtonCallback:^ (MessageBannerView* banner) {
                                         
                                         [MessageBanner hideMessageBannerWithCompletion:^{
                                             NSLog(@"Dismissed");
                                         }];
                                         return ;
                                     }
                                         atPosition:self.messagePosition
                               canBeDismissedByUser:self.userDismissEnabled
                                           delegate:self];

    
    
    NSLog(@"Banner with :\n{\n"
          "Title: [%@]\n "
          "Subtitle: [%@]\n"
          "Image: [%@]\n"
          "Type: [%@]\n"
          "Duration: [%f]\n"
          "Position: [%@]\n"
          "User interaction allowed: [%@]\n"
          "}\n is [SHOWED]."
          , self.bannerTitle
          , self.subTitle
          , (self.image ? @"Icon setted." : @"No icon setted.")
          , [self getTypeDescription:self.messageType]
          , self.duration
          , [self getPositionDescription:self.messagePosition]
          , (self.userDismissEnabled ? @"YES" : @"NO")
          );
}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Segmented Control Methods

- (IBAction)subtitleSegmentedControlValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0: {
            self.bannerTitle = @"Small Title.";
            self.subTitle = @"Small subtitle.";
            break;
        }
        case 1: {
            self.bannerTitle = @"This title is a medium title, with not too much characters.";
            self.subTitle = @"This text is a medium subtitle, with not too much characters.";
            break;
        }
        case 2: {
            self.bannerTitle = @"This text is written to be a very long title, it has a lot of text. And everything works fine, isn't it great ?";
            self.subTitle = @"This text is written to be a very long subtitle, it has a lot of text. And everything works fine, isn't it great ?";
            break;
        }
        default:
            break;
    }
}

- (IBAction)imageSegmentedControlValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: {
            self.image = nil;
            break;
        }
        case 1: {
            self.image = [UIImage imageNamed:@"iconTest"];
            break;
        }
        default:
            break;
    }
}

- (IBAction)messageTypeSegmentedControlValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: {
            self.messageType = MessageBannerTypeError;
            break;
        }
        case 1: {
            self.messageType = MessageBannerTypeWarning;
            break;
        }
        case 2: {
            self.messageType = MessageBannerTypeMessage;
            break;
        }
        case 3: {
            self.messageType = MessageBannerTypeSuccess;
            break;
        }
        default:
            break;
    }
}

- (IBAction)messagePositionSegmentedControlValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: {
            self.messagePosition = MessageBannerPositionTop;
            break;
        }
        case 1: {
            self.messagePosition = MessageBannerPositionCenter;
            break;
        }
        case 2: {
            self.messagePosition = MessageBannerPositionBottom;
            break;
        }
        default:
            break;
    }
}

- (IBAction)userDismissEnabledSegmentedControlChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == NO && self.durationSlider.value == -1.0f) {
        [self.durationSlider setValue:0 animated:YES];
        [self durationSliderValueChanged:self.durationSlider];
    }
    self.userDismissEnabled = sender.selectedSegmentIndex;
    
}

- (IBAction)buttonEnabledSegmentedControlChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.buttonTitle = nil;
    } else {
        self.buttonTitle = @"Dismiss";
    }
        
}


#pragma mark -
#pragma mark UISlider methods

- (IBAction)durationSliderValueChanged:(UISlider *)sender {
    if (self.userDismissSegmentedControl.selectedSegmentIndex == NO && sender.value == -1.0f) {
        [self.userDismissSegmentedControl setSelectedSegmentIndex:YES];
        [self userDismissEnabledSegmentedControlChanged:self.userDismissSegmentedControl];
    }
    
    int rounded = sender.value;  //Casting to an int will truncate, round down
    [sender setValue:rounded animated:NO];
    
    switch (rounded) {
        case -1: {
            self.durationLabel.text = @"Endless";
            self.duration = MessageBannerDurationEndless;
            break;
        }
        case 0: {
            self.durationLabel.text = @"Automatic";
            self.duration = MessageBannerDurationDefault;
            break;
        }
        default: {
            self.durationLabel.text = [NSString stringWithFormat:@"%d seconds", rounded];
            self.duration = rounded;
            break;
        }
    }
}

@end
