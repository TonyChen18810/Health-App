//
//  OtherTestVC.m
//  OneTrackHealth
//
//  Created by Tristate on 6/19/19.
//  Copyright © 2019 Tristate. All rights reserved.
//

#import "OtherTestVC.h"

@interface OtherTestVC ()

@end

@implementation OtherTestVC

#pragma mark - View LifeCycle-

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
}

- (IBAction)btnBack :(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
