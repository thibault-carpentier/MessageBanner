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
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) CGFloat duration;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.subTitle = @"Small subtitle.";
    self.image = nil;
    self.duration = MessageBannerDurationEndless;
    self.messageType = MessageBannerNotificationTypeError;
    self.messagePosition = MessageBannerPositionTop;
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
    
    [MessageBanner showNotificationInViewController:self
                                              title:@"TITLE"
                                           subtitle:self.subTitle
                                              image:self.image
                                               type:self.messageType
                                           duration:self.duration
                                           callback:^{
                                               NSLog(@"Banner Top Dismissed");
                                               
                                               return ;
                                           }
                                        buttonTitle:@""
                                     buttonCallback:^{
                                         return ;
                                     }
                                         atPosition:self.messagePosition
                               canBeDismissedByUser:YES];
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

- (IBAction)SubtitleSegmentedControlValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0: {
            self.subTitle = @"Small subtitle.";
            break;
        }
        case 1: {
            self.subTitle = @"This text is a medium subtitle, with not too much characters.";
            break;
        }
        case 2: {
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
            self.messageType = MessageBannerNotificationTypeError;
            break;
        }
        case 1: {
            self.messageType = MessageBannerNotificationTypeWarning;
            break;
        }
        case 2: {
            self.messageType = MessageBannerNotificationTypeMessage;
            break;
        }
        case 3: {
            self.messageType = MessageBannerNotificationTypeSuccess;
            break;
        }
        default:
            break;
    }
}

- (IBAction)messagePositionSegmentedControlValueChanger:(UISegmentedControl *)sender {
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

#pragma mark -
#pragma mark UISlider methods

- (IBAction)durationSliderValueChanged:(UISlider *)sender {
    int rounded = sender.value;  //Casting to an int will truncate, round down
    [sender setValue:rounded animated:NO];
    
    switch (rounded) {
        case -1: {
            self.durationLabel.text = @"Endless";
            self.duration = MessageBannerDurationEndless;
            break;
        }
        case 0: {
            self.durationLabel.text = @"Default";
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
