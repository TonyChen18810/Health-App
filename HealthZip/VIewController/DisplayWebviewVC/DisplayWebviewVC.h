//
//  DisplayWebviewVC.h
//  HealthZip
//
//  Created by Tristate on 6/15/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface DisplayWebviewVC : BaseViewController<WKNavigationDelegate,WKUIDelegate>


@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) NSString  *strUrl;
- (IBAction)btnBackClickAction:(id)sender;

@end
