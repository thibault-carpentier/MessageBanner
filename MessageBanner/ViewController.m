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
@property (nonatomic, assign) MessageBannerType messageType;
@property (nonatomic, assign) NSString *bannerTitle;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BOOL userDismissEnabled;

@property (weak, nonatomic) IBOutlet UISegmentedControl *userDismissSegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

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
    
    [MessageBanner showMessageBannerInViewController:self
                                              title:self.bannerTitle
                                           subtitle:self.subTitle
                                              image:self.image
                                               type:self.messageType
                                           duration:self.duration
                                           userDissmissedCallback:^(MessageBannerView* message) {
                                               NSLog(@"Banner with :\n{\n"
                                                     "Title: [%@]\n "
                                                     "Subtitle: [%@]\n"
                                                     "Image: [%@]\n"
                                                     "Type: [%@]\n"
                                                     "Duration: [%f]\n"
                                                     "Position: [%@]\n"
                                                     "User interaction allowed: [%@]\n"
                                                     "}\n has been dismissed."
                                                     , self.title
                                                     , self.subTitle
                                                     , (self.image ? @"Icon setted." : @"No icon setted.")
                                                     , @"TYPE"
                                                     , self.duration
                                                     , @"POSITION"
                                                     , (self.userDismissEnabled ? @"YES" : @"NO")
                                                     );
                                               
                                               return ;
                                           }
                                        buttonTitle:@""
                                     buttonCallback:^{
                                         return ;
                                     }
                                         atPosition:self.messagePosition
                               canBeDismissedByUser:self.userDismissEnabled];
    NSLog(@"Banner with :\n{\n"
          "Title: [%@]\n "
          "Subtitle: [%@]\n"
          "Image: [%@]\n"
          "Type: [%@]\n"
          "Duration: [%f]\n"
          "Position: [%@]\n"
          "User interaction allowed: [%@]\n"
          "}\n is [SHOWED]."
          , self.title
          , self.subTitle
          , (self.image ? @"Icon setted." : @"No icon setted.")
          , @"TYPE"
          , self.duration
          , @"POSITION"
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
