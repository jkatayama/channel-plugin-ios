//
//  MainViewController.m
//  Channel Plugin Sample objc
//
//  Created by Haeun Chung on 21/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

#import "VeilViewController.h"
#import <ChannelIO/ChannelIO-Swift.h>

@interface VeilViewController ()

@end

@implementation VeilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pluginKeyField.placeholder = @"Insert your pluginKey";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didClickOnBoot:(id)sender {
  ChannelPluginSettings *settings = [[ChannelPluginSettings alloc] init];
  [settings setPluginKey:@"06ccfc12-a9fd-4c68-b364-5d19f81a60dd"];
  
  [ChannelIO bootWith:settings profile:nil completion:^(ChannelPluginCompletionStatus status, Guest* guest) {
    
  }];
}

- (IBAction)didClickOnShutdown:(id)sender {
  [ChannelIO shutdown];
}

- (IBAction)didClickOnShowLauncher:(id)sender {
  [ChannelIO showWithAnimated:YES];
}

- (IBAction)didClickOnHideLauncher:(id)sender {
  [ChannelIO hideWithAnimated:YES];
}

- (IBAction)didClickOnOpenChat:(id)sender {
  [ChannelIO openWithAnimated:YES];
}
@end
