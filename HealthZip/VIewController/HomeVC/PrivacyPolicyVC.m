//
//  PrivacyPolicyVC.m
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 14/09/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "PrivacyPolicyVC.h"
#import "Webservice.h"
@interface PrivacyPolicyVC ()

@end

@implementation PrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    [self callwebservice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCloseAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)callwebservice{
    if ([self isNetworkReachable]) {
        [_indicater startAnimating];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        
        [webserviceObj callJSONMethod:@"get_privacy_policy" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            
            NSString *strMsg=[dict valueForKey:@"message"];
            if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                NSDictionary *dataDict=[[dict valueForKey:@"data"] objectAtIndex:0];
                NSString *strWV=[dataDict objectForKey:@"privacyPolicy"];
                 [self.wvPrivacyPolicy loadHTMLString:strWV baseURL:nil];
                self.wvPrivacyPolicy.UIDelegate = self;
                self.wvPrivacyPolicy.navigationDelegate = self;
            }
            else{
                [self->_indicater stopAnimating];
                [UIAlertController infoAlertWithMessage:strMsg andTitle:APPNAME controller:self];
            }
            
            
        } onFailure:^(NSError *error) {
            [self->_indicater stopAnimating];
            [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
            
        }];
    }
    else{
        [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
    }
}

#pragma mark - WKWEBVIEW METHODS -
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [_indicater startAnimating];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_indicater stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [_indicater stopAnimating];
    NSURL* failingURL = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];
    if ([failingURL.absoluteString isEqualToString:@"about:blank"]) {
        NSLog(@"  This is Blank. Ignoring.");
    }
    else {
        NSLog(@"  This is a real URL.");
    }
}
@end
