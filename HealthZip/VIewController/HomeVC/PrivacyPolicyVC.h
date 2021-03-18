//
//  PrivacyPolicyVC.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 14/09/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface PrivacyPolicyVC : BaseViewController<WKNavigationDelegate,WKUIDelegate>


@property (weak, nonatomic) IBOutlet WKWebView *wvPrivacyPolicy;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicater;

- (IBAction)btnCloseAction:(id)sender;
@end
