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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)popTop:(id)sender {
    [MessageBanner showNotificationInViewController:self title:@"TITLE" subtitle:@"This is a standart subtitle" image:[UIImage imageNamed:@"toto"] type:MessageBannerNotificationTypeMessage duration:1.0 callback:^{
        return ;
    } buttonTitle:@"" buttonCallback:^{
        return ;
    } atPosition:MessageBannerPositionTop canBeDismissedByUser:YES];
}

- (IBAction)popMeOne:(id)sender {
    
    [MessageBanner showNotificationInViewController:self title:@"TITLE" subtitle:@"This is a standart subtitle" image:[UIImage imageNamed:@"toto"] type:MessageBannerNotificationTypeMessage duration:1.0 callback:^{
        return ;
    } buttonTitle:@"" buttonCallback:^{
        return ;
    } atPosition:MessageBannerPositionCenter canBeDismissedByUser:YES];
}

- (IBAction)popBottom:(id)sender {
    [MessageBanner showNotificationInViewController:self title:@"TITLE" subtitle:@"This is a standart subtitle" image:[UIImage imageNamed:@"toto"] type:MessageBannerNotificationTypeMessage duration:1.0 callback:^{
        return ;
    } buttonTitle:@"" buttonCallback:^{
        return ;
    } atPosition:MessageBannerPositionBottom canBeDismissedByUser:YES];
}


-(void)viewDidAppear:(BOOL)animated {
    
    NSString* subtitle;
    
    subtitleTestType test = bigSubtitle;
    switch (test) {
        case shortSubtitle:
            subtitle = @"subtitle";
            break;
        case medSubtitle:
            subtitle = @"Medium size Subtitle for example test";
            break;
        case bigSubtitle:
            subtitle = @"subtitle very very very very very very very very very very very very very very very very very very very very very very very very very very  Long very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very  Long";
            break;
        
        default:
           subtitle =  @"subtitle very very very very very very very very 1very very very very very very very very very very very very very very very very very very  Long very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very  Long";
            break;
    }
   

    [MessageBanner showNotificationInViewController:self title:@"TITLE" subtitle:subtitle image:[UIImage imageNamed:@"toto"] type:MessageBannerNotificationTypeMessage duration:1.0 callback:^{
        return ;
    } buttonTitle:@"" buttonCallback:^{
        return ;
    } atPosition:MessageBannerPositionTop canBeDismissedByUser:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
