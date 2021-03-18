//
//  DisplayWebviewVC.m
//  HealthZip
//
//  Created by Tristate on 6/15/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "DisplayWebviewVC.h"

@interface DisplayWebviewVC ()

@end

@implementation DisplayWebviewVC
@synthesize webView,strUrl;


#pragma mark - VIEW LIFECYCLE METHODS

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    // Do any additional setup after loading the view.
    

    [self.spinner startAnimating];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WKWEBVIEW METHODS -
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self.spinner startAnimating];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.spinner stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.spinner stopAnimating];
    [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
}

- (IBAction)btnBackClickAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
